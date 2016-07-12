#
# Cookbook Name:: instana-agent-onprem
# Recipe:: run
#
# Copyright 2016, 2016 Instana, Inc.
#
# All rights reserved - Do Not Redistribute
#

dest_path = "#{node['instana']['agent']['dest_path']}/instana-agent/bin/start"

execute 'Start Instana agent' do
  command dest_path
  returns 0
  timeout 600
  action :run
  only_if { File.exists? dest_path }
end
