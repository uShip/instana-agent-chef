# encoding: utf-8

#
# Cookbook Name:: instana-agent
# Recipe:: default
#
# Copyright 2017, INSTANA Inc
#

log 'fail if flavor is of unknown type' do
	message <<-EOT
		The flavor attribute for the agent must be either
		"dynamic" or "static".
	EOT
	level :error
	not_if { %w[dynamic static].include? node['instana']['agent']['flavor'] }
end

include_recipe 'instana-agent::system'
include_recipe 'instana-agent::backend_config'
include_recipe 'instana-agent::mirrors_config'
include_recipe 'instana-agent::source_update'
include_recipe 'instana-agent::agent_config'

file "#{node['instana']['agent']['config_dir']}/com.instana.agent.main.config.Agent.cfg" do
	mode '0640'
	owner 'root'
	group 'root'
	action :create_if_missing
end

# TODO revisit this
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
	subscribes :restart, "execute[systemd-daemon-reload]"
	subscribes :restart, "template[/opt/instana/agent/etc/mvn-settings.xml]"
	subscribes :restart, "template[/opt/instana/agent/etc/org.ops4j.pax.url.mvn.cfg]"
end
