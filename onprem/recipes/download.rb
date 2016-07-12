#
# Cookbook Name:: instana-agent-onprem
# Recipe:: download
#
# Copyright 2016, 2016 Instana, Inc.
#
# All rights reserved - Do Not Redistribute
#

architecture = node['instana']['agent']['architecture']
os = node.default['instana']['agent']['os']
email = node['instana']['endpoint']['email']
password = node['instana']['endpoint']['password']
tenant = node['instana']['endpoint']['tenant']
unit = node['instana']['endpoint']['unit']
dest_path = node['instana']['agent']['dest_path']
endpoint = node['instana']['endpoint']['url']
endpoint = "#{endpoint}/" if endpoint.reverse[1] != '/'

login_url = "#{endpoint}auth/signIn"
agent_url = "#{endpoint}ump/#{tenant}/#{unit}/agent/download"

creds = "--data-ascii 'email=#{node['instana']['endpoint']['email']}"
creds << "&password=#{node['instana']['endpoint']['password']}'"
agentpath = "-o /tmp/instana-agent.tgz"

arch_param = "--data-ascii type=#{os}#{architecture}"
arch_param = "--data-ascii type=mac" if os == 'mac'

tmp_cpath = '/tmp/cookiejar.txt'

if node.default.key?('javaloc')
  jloc = node.default['javaloc']
elsif ENV.key?('JAVA_HOME')
  jloc = ENV['JAVA_HOME']
end

execute 'Get Login token' do
  command "curl -k -c #{tmp_cpath} #{creds} #{login_url}"
  creates tmp_cpath
  returns 0
  timeout 600
  action :run
end

execute 'Get Instana agent download' do
  command "curl -XPOST -k -b #{tmp_cpath} #{arch_param} #{agentpath} #{agent_url}"
  creates '/tmp/instana-agent.tgz'
  returns 0
  timeout 600
  action :run
end
