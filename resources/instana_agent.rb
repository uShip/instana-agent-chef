resource_name :instana_agent
property :flavor, String, name_property: true
property :key, String, required: true, sensitive: true

action :install do
	include_recipe 'zypper::default' if node['platform_family'] == 'suse'

	systemd_srv_dir = '/etc/systemd/system/instana-agent.service.d'
	gpg_path = 'https://packages.instana.io/Instana.gpg'
	domain = "https://_:#{new_resource.key}@packages.instana.io"

	if node['platform'] == 'windows'
		reboot 'powershell' do
			action :nothing
		end

		# Need Powershell 5 so we're going to install that as part of WMF 5.1
		msu_package 'Windows Management Framework Core 5.1' do # ~FC009
			source 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu'
			checksum 'a8d788fa31b02a999cc676fb546fc782e86c2a0acd837976122a1891ceee42c0'
			action :install
			notifies :reboot_now, 'reboot[powershell]', :immediately
		end

		agent_key = node['instana']['agent']['key']
		base_url = node['instana']['agent']['base_url']
		base_artifact_name = 'agent-assembly-offline-1.0.0-'
		artifact_name = "#{base_artifact_name}#{node['instana']['agent']['windows']['build_date']}.#{node['instana']['agent']['windows']['build_number']}-windows-64bit-offline.zip"
		archive_url = "https://_:#{agent_key}@#{base_url}/#{artifact_name}"

		remote_file "#{Chef::Config['file_cache_path']}\\instana_agent.zip" do
			source archive_url
		end

		powershell_script 'extract_instana' do
			code <<~PSH
				Expand-Archive -LiteralPath '#{Chef::Config['file_cache_path']}\\instana_agent.zip' -DestinationPath #{node['instana']['agent']['windows']['dir']}
			PSH
			not_if 'Get-Service -name "Instana Agent" | Where-Object {$_.Status -eq "Running"}'
		end

		windows_config_dir =
			"#{node['instana']['agent']['windows']['dir']}\\instana-agent\\etc\\instana"

		template "#{windows_config_dir}\\com.instana.agent.main.sender.Backend.cfg" do
			source 'agent_backend.erb'
			cookbook 'instana-agent'
			sensitive true
			variables(
				config_vars.merge key: new_resource.key
			)
		end

		# This is the service wrapper file that was downloaded from https://github.com/kohsuke/winsw per
		# the instructions at https://docs.instana.io/quick_start/agent_setup/windows/#service-wrapper-download
		cookbook_file "#{node['instana']['agent']['windows']['dir']}\\instana-agent.exe" do
			source 'instana-agent'
			cookbook 'instana-agent'
		end

		# Configuration file for the service wrapper per https://docs.instana.io/quick_start/agent_setup/windows/#service-wrapper-configuration-file
		template "#{node['instana']['agent']['windows']['dir']}\\instana-agent.xml" do
			source 'instana-agent.xml.erb'
			cookbook 'instana-agent'
			variables(
				instana_agent_dir: "#{node['instana']['agent']['windows']['dir']}\\instana-agent",
			)
		end

		powershell_script 'install_instana' do
			code '.\instana-agent.exe install'
			cwd node['instana']['agent']['windows']['dir']
			not_if 'Get-Service -name "Instana Agent"'
		end

		powershell_script 'run_instana' do
			code 'Start-Service -displayName "Instana Agent"'
			# not_if 'Get-Service -name "Instana Agent" | Where-Object {$_.Status -eq "Running"}'
		end
	else
		if node['platform_family'] == 'debian'
			package 'apt-transport-https' do
				action :install
			end

			apt_repository 'Instana-Agent' do
				repo_name 'instana-agent'
				distribution 'generic'
				arch 'amd64'
				key gpg_path
				uri "#{domain}/agent"
				components ['main']
				action :add
			end

			apt_update 'instana-agent' do
				action :update
			end
		end

		yum_repository 'Instana-Agent' do
			description 'The Agent repository by Instana, Inc.'
			baseurl "#{domain}/agent/generic/x86_64"
			gpgkey gpg_path
			repo_gpgcheck true
			gpgcheck false
			action %i[create makecache]
			only_if { %w[rhel suse amazon].include? node['platform_family'] }
		end

		zypper_repo 'Instana-Agent' do
			action :add
			key gpg_path
			uri "#{domain}/agent/generic/x86_64"
			only_if { node['platform_family'] == 'suse' }
		end

		package 'instana-agent' do
			package_name "instana-agent-#{node['instana']['agent']['flavor']}"
			action :upgrade
		end

		directory systemd_srv_dir do
			owner 'root'
			group 'root'
			mode '0644'
			action :create
			only_if { node['init_package'] == 'systemd' }
		end

		template "#{systemd_srv_dir}/10-resources.conf" do
			source 'systemd_resources.erb'
			cookbook 'instana-agent'
			owner 'root'
			group 'root'
			mode '0644'
			action :create
			variables(
				limit_cpu: node['instana']['agent']['limit']['cpu']['enabled'],
				cpu_quota: node['instana']['agent']['limit']['cpu']['quota'],
				limit_memory: node['instana']['agent']['limit']['memory']['enabled'],
				memory_quota: node['instana']['agent']['limit']['memory']['maxsize'],
			)
			only_if do
				node['init_package'] == 'systemd' &&
					(node['instana']['agent']['limit']['cpu']['enabled'] ||
					 node['instana']['agent']['limit']['memory']['enabled'])
			end
			notifies :run, 'execute[systemd-daemon-reload]'
		end

		execute 'systemd-daemon-reload' do
			action :nothing
			command 'systemctl daemon-reload'
		end

		template "#{node['instana']['agent']['config_dir']}/com.instana.agent.main.sender.Backend.cfg" do
			source 'agent_backend.erb'
			cookbook 'instana-agent'
			mode '0640'
			owner 'root'
			group 'root'
			sensitive true
			variables(
				config_vars.merge key: new_resource.key
			)
		end

		template '/opt/instana/agent/etc/mvn-settings.xml' do
			source 'maven_settings.erb'
			cookbook 'instana-agent'
			mode '0640'
			owner 'root'
			group 'root'
			sensitive true
			variables(
				config_vars.merge key: new_resource.key
			)
		end

		template '/opt/instana/agent/etc/org.ops4j.pax.url.mvn.cfg' do
			source 'pax_maven_cfg.erb'
			cookbook 'instana-agent'
			mode '0640'
			owner 'root'
			group 'root'
		end

		template "#{node['instana']['agent']['config_dir']}/com.instana.agent.main.config.UpdateManager.cfg" do
			source 'agent_update.erb'
			cookbook 'instana-agent'
			mode '0640'
			owner 'root'
			group 'root'
			action :create
			variables(
				interval: node['instana']['agent']['update']['interval'],
				enabled: (node['instana']['agent']['update']['enabled'] ? 'AUTO' : 'OFF'),
				time: node['instana']['agent']['update']['time']
			)
			only_if do
				node['instana']['agent']['update']['pin'] == '' &&
					node['instana']['agent']['update']['enabled']
			end
		end

		template "#{node['instana']['agent']['config_dir']}/com.instana.agent.bootstrap.AgentBootstrap.cfg" do
			source 'agent_bootstrap.erb'
			cookbook 'instana-agent'
			mode '0640'
			owner 'root'
			group 'root'
			action :create
			variables(
				version: node['instana']['agent']['update']['pin']
			)
		end

		template "#{node['instana']['agent']['config_dir']}/configuration.yaml" do
			source 'agent_config.erb'
			cookbook 'instana-agent'
			mode '0640'
			owner 'root'
			group 'root'
			variables(
				zone: node['instana']['agent']['zone'],
				tags: node['instana']['agent']['tags']
			)
		end

		ruby_block 'set the agent mode (default APM)' do
			block do
				case node['instana']['agent']['mode']
				when 'INFRASTRUCTURE', 'infrastructure', 'infra'
					value = 'INFRASTRUCTURE'
				when 'off', 'OFF', false
					value = 'OFF'
				else
					value = 'APM'
				end
				line = "mode = #{value}"
				path = "#{node['instana']['agent']['config_dir']}/com.instana.agent.main.config.Agent.cfg"
				file = Chef::Util::FileEdit.new(path)
				file.search_file_replace_line(/^mode =.*/, line)
				file.insert_line_if_no_match(/^mode =.*/, line)
				file.write_file
			end
		end

		service 'instana-agent' do
			supports status: true, restart: true
			action [:enable, :start]
			subscribes :restart, 'execute[systemd-daemon-reload]'
			subscribes :restart, 'template[/opt/instana/agent/etc/mvn-settings.xml]'
			subscribes :restart, 'template[/opt/instana/agent/etc/org.ops4j.pax.url.mvn.cfg]'
		end
	end
end

def config_vars
	_ = {
		host: node['instana']['agent']['endpoint']['host'],
		port: node['instana']['agent']['endpoint']['port'],
		proxy_enabled: node['instana']['agent']['proxy']['enabled'],
		proxy_type: node['instana']['agent']['proxy']['type'],
		proxy_host: node['instana']['agent']['proxy']['host'],
		proxy_port: node['instana']['agent']['proxy']['port'],
		proxy_dns: node['instana']['agent']['proxy']['dns'],
		proxy_username: node['instana']['agent']['proxy']['username'],
		proxy_password: node['instana']['agent']['proxy']['password'],
		mirrors_enabled: node['instana']['agent']['mirror']['enabled'],
		mirrors_require_auth: node['instana']['agent']['mirror']['auth']['enabled'],
		mirrors_username: node['instana']['agent']['mirror']['auth']['username'],
		mirrors_password: node['instana']['agent']['mirror']['auth']['password'],
		release_repourl: node['instana']['agent']['mirror']['urls']['release'],
		shared_repourl: node['instana']['agent']['mirror']['urls']['shared']
	}
end
