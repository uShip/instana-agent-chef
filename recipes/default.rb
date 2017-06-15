# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: default
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

log 'fail if jdk not set for minimal install' do
  message <<-EOT
    When picking the minimal installation method for the Instana Agent,
    please specify a path to an Oracle- or OpenJDK.
  EOT
  level :error
  only_if do
    node['instana']['agent']['flavor'] == 'minimal' && node['instana']['agent']['jdk'] == ''
  end
end

log 'fail if flavor is of unknown type' do
  message <<-EOT
    The flavor attribute for the agent must be of either "full" or "minimal" value.
  EOT
  level :error
  not_if { %w(full minimal).include? node['instana']['agent']['flavor'] }
end

http_request 'check agent key for validity before making system changes' do
  action :get
  url 'https://packages.instana.io/agent/generic/x86_64/repodata/repomd.xml'
  headers(Authorization: "Basic #{::Base64.encode64("_:#{node['instana']['agent']['agent_key']}")}")
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
  only_if { %w(suse rhel).include? node['platform_family'] }
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
