# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: default
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

node.default['instana']['agent']['flavor'] = 'full'
node.default['instana']['agent']['agentKey'] =''
node.default['instana']['agent']['hostTags'] = []
node.default['instana']['agent']['jdk'] = ''

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
  arch 'amd64'
  key 'https://packages.instana.io/Instana.gpg'
  uri "https://_:#{node['instana']['agent']['agentKey']}@packages.instana.io/agent"
  components ['main']
  action :add
end

yum_repository 'Instana-Agent' do
  description 'The Agent repository by Instana, Inc.'
  baseurl "https://_:#{node['instana']['agent']['agentKey']}@packages.instana.io/agent/generic/x86_64"
  gpgkey 'https://packages.instana.io/Instana.gpg'
  action [:create, :makecache]
end

package 'instana-agent' do
  package_name "instana-agent-#{node['instana']['agent']['flavor']}"
  action :upgrade
end
