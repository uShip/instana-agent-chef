# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: download
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

path = node['instana']['tenant']['agentDest']

execute 'Unzip Instana agent' do
  command "#{path}/bin/start"
  returns 0
  timeout 600
  action :run
  not_if { File.exists? "#{path}/bin/start" }
end
