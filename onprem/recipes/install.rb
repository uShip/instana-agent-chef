#
# Cookbook Name:: instana-agent-onprem
# Recipe:: install
#
# Copyright 2016, 2016 Instana, Inc.
#
# All rights reserved - Do Not Redistribute
#

dest_path = node['instana']['agent']['dest_path']
already_populated = File.exists? "#{dest_path}/instana-agent/bin/start.sh"

directory 'Create Instana agent directory' do
  group 'root'
  mode  '0755'
  owner 'root'
  path dest_path
  action :create
  not_if { File.directory? dest_path }
end

execute 'Unzip Instana agent archive' do
  command "tar xfvz /tmp/instana-agent.tgz -C #{dest_path}"
  creates "#{dest_path}/instana-agent/bin/start.sh"
  returns 0
  timeout 600
  action :run
  only_if { File.exists? '/tmp/instana-agent.tgz' }
  not_if { already_populated }
end
