# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: default
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

log 'jdk not set' do
  message <<-EOT
    When picking the minimal installation method for the Instana Agent,
    please specify a path to an Oracle JDK.
  EOT
  level :error
  only_if do
    node['instana']['agent']['flavor'] == 'minimal' &&
        node['instana']['agent']['jdk'] == ''
  end
end

log 'jdk invalid' do
  message <<-EOT
    We think the path you have specified does not classify as an Oracle JDK.
    Please check the path and run the script again.
  EOT
  level :error
  only_if do
    node['instana']['agent']['flavor'] == 'minimal' &&
        node['instana']['agent']['jdk'] != '' &&
        !File.exist?("#{node['instana']['agent']['jdk']}/lib/tools.jar")
  end
end

apt_repository 'Instana-Agent' do
  repo_name 'Instana-Agent'
  distribution 'generic'
  arch 'amd64'
  key 'https://packages.instana.io/Instana.gpg'
  uri "https://_:#{node['instana']['agent']['agent_key']}@packages.instana.io/agent"
  components ['main']
  action :add
  only_if { node['platform_family'] == 'debian' }
end

yum_repository 'Instana-Agent' do
  description 'The Agent repository by Instana, Inc.'
  baseurl "https://_:#{node['instana']['agent']['agent_key']}@packages.instana.io/agent/generic/x86_64"
  gpgkey 'https://packages.instana.io/Instana.gpg'
  repo_gpgcheck true
  gpgcheck false
  action [:create, :makecache]
  only_if { %w(suse rhel fedora).include? node['platform_family'] }
end

package 'instana-agent' do
  package_name "instana-agent-#{node['instana']['agent']['flavor']}"
  action :upgrade
end

template '/opt/instana/agent/etc/instana/com.instana.agent.main.sender.Backend.cfg' do
  source 'agent-backend.erb'
  mode '0640'
  owner 'root'
  group 'root'
  variables({
    key: node['instana']['agent']['agent_key'],
    host: node['instana']['agent']['endpoint']['host'],
    port: node['instana']['agent']['endpoint']['port']
  })
end

template '/opt/instana/agent/etc/instana/com.instana.agent.main.config.UpdateManager.cfg' do
  source 'agent-update.erb'
  mode '0640'
  owner 'root'
  group 'root'
  variables({
    interval: node['instana']['agent']['update']['interval'],
    enabled: (node['instana']['agent']['update']['enabled'] ? 'AUTO' : 'OFF'),
    time: node['instana']['agent']['update']['time']
  })
end

service 'instana-agent' do
  action [:enable, :start]
end
