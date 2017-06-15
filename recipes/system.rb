# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: repository

systemd_srv_dir = '/etc/systemd/system/instana-agent.service.d'
domain = "https://_:#{node['instana']['agent']['agent_key']}@"
domain << 'packages.instana.io'

permissions = "#{node['instana']['agent']['user']}:"
permissions << node['instana']['agent']['group']

ruby_block 'check user/group permissions' do
  block do
    unless node['etc']['passwd'].key? node['instana']['agent']['user']
      msg = 'Your requested user does not seem to exist on this system.'
      msg << ' Please make sure it does before running this cookbook again.'
      raise msg
    end
    unless node['etc']['group'].key? node['instana']['agent']['group']
      msg = 'Your requested group does not seem to exist on this system.'
      msg << ' Please make sure it does before running this cookbook again.'
      raise msg
    end
  end
  only_if do
    (node['instana']['agent']['user'] != 'root' ||
      node['instana']['agent']['group'] != 'root')
  end
end

package 'apt-transport-https' do
  action :install
  only_if { node['platform_family'] == 'debian' }
end

apt_repository 'Instana-Agent' do
  repo_name 'Instana-Agent'
  distribution 'generic'
  arch 'amd64'
  key 'https://packages.instana.io/Instana.gpg'
  uri "#{domain}/agent"
  components ['main']
  action :add
  only_if { node['platform_family'] == 'debian' }
end

yum_repository 'Instana-Agent' do
  description 'The Agent repository by Instana, Inc.'
  baseurl "#{domain}/agent/generic/x86_64"
  gpgkey 'https://packages.instana.io/Instana.gpg'
  repo_gpgcheck true
  gpgcheck false
  action [:create, :makecache]
  only_if { %w(suse rhel amazon).include? node['platform_family'] }
end

package 'instana-agent' do
  package_name "instana-agent-#{node['instana']['agent']['flavor']}"
  action :upgrade
end

service 'stop the instana agent until it\'s configured' do
  service_name 'instana-agent'
  action :stop
end

execute 'recursively chown agent dir to user/group' do
  command "chown -R #{permissions} /opt/instana/agent"
  action :run
  only_if do
    (node['instana']['agent']['user'] != 'root' ||
      node['instana']['agent']['group'] != 'root')
  end
end

directory systemd_srv_dir do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  only_if do
    (node['instana']['agent']['user'] != 'root' ||
      node['instana']['agent']['group'] != 'root') &&
      node['init_package'] == 'systemd'
  end
end

template "#{systemd_srv_dir}/10-users.conf" do
  source 'systemd_service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
  variables(
    user: node['instana']['agent']['user'],
    group: node['instana']['agent']['group']
  )
  only_if do
    (node['instana']['agent']['user'] != 'root' ||
      node['instana']['agent']['group'] != 'root') &&
      node['init_package'] == 'systemd'
  end
end

template "#{systemd_srv_dir}/20-resources.conf" do
  source 'systemd_service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
  variables(
    limit_cpu: node['instana']['agent']['limit']['cpu']['enabled'],
    cpu_quota: node['instana']['agent']['limit']['cpu']['quota'],
    limit_memory: node['instana']['agent']['limit']['memory']['enabled'],
    memory_quota: node['instana']['agent']['limit']['memory']['maxsize']
  )
  only_if do
    node['init_package'] == 'systemd' &&
      (node['instana']['agent']['limit']['cpu']['enabled'] ||
        node['instana']['agent']['limit']['memory']['enabled'])
  end
end

template '/etc/default/instana-agent' do
  source 'sysvinit_service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
  variables(
    user: node['instana']['agent']['user'],
    group: node['instana']['agent']['group']
  )
  only_if do
    (node['instana']['agent']['user'] != 'root' ||
      node['instana']['agent']['group'] != 'root') &&
      node['init_package'] != 'systemd' &&
      ::Dir.exist?('/etc/default')
  end
end

template '/etc/sysconfig/instana-agent' do
  source 'sysvinit_service.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
  variables(
    user: node['instana']['agent']['user'],
    group: node['instana']['agent']['group']
  )
  only_if do
    (node['instana']['agent']['user'] != 'root' ||
      node['instana']['agent']['group'] != 'root') &&
      node['init_package'] != 'systemd' &&
      !::Dir.exist?('/etc/default')
  end
end
