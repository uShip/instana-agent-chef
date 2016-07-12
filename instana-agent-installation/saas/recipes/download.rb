# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: download
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

api_err = 'The API responded with a not known status. Please contact us!'
msg401 = 'Your login request failed! Please check your instana credentials!'
dl_msg = 'Your download request failed! Please check your connectivity!'
tmp_cpath = '/tmp/cookiejar.txt'
to_null = '>/dev/null 2>&1'
arch = '--data "type=linux64"'

tenant = node['instana']['tenant']['name']
unit = node['instana']['tenant']['unit']
login_url = "https://#{unit}-#{tenant}.instana.io/auth/signIn"
agent_url = "https://instana.io/ump/#{tenant}/#{unit}/agent/download"
creds = "--data-ascii 'email=#{node['instana']['tenant']['email']}"
creds << "&password=#{node['instana']['tenant']['password']}'"
agentpath = "-o #{node.default['instana']['tenant']['agentSrc']}"

file tmp_cpath do
  action :delete
  only_if { File.exists? tmp_cpath }
end

file node.default['instana']['tenant']['agentSrc'] do
  action :delete
  only_if { File.exists? node.default['instana']['tenant']['agentSrc'] }
end

execute 'Get Login token' do
  command "curl -c #{tmp_cpath} #{creds} #{login_url} #{to_null}"
  creates tmp_cpath
  returns 0
  timeout 600
  action :run
end

execute 'Get Instana agent download' do
  command "curl -b #{tmp_cpath} #{arch} #{agent_url} #{agentpath} #{to_null}"
  creates node.default['instana']['tenant']['agentSrc']
  returns 0
  timeout 600
  action :run
end
