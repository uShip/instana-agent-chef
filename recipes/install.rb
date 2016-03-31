# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: download
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

archive_src = node['instana']['tenant']['agentSrc']
dest_path = node['instana']['tenant']['agentDest']
already_populated = File.exists? "#{dest_path}/bin/start.sh"

file 'Create Instana agent directory' do
  group 'root'
  mode  '0755'
  owner 'root'
  path dest_path
  action :create
  not_if { File.directory? dest_path }
end

execute 'Unzip Instana agent' do
  command "tar xfvz #{archive_src} -C #{dest_path}"
  creates dest_path
  returns 0
  timeout 600
  action :run
  not_if { already_populated }
end
