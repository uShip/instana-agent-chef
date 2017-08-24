# encoding: utf-8

#
# Cookbook Name:: instana-agent
# Recipe:: backend_config
#
# Copyright 2017, INSTANA Inc
#

template "#{node['instana']['agent']['config_dir']}/com.instana.agent.main.sender.Backend.cfg" do
	source 'agent_backend.erb'
	mode '0640'
	owner 'root'
	group 'root'
	variables(
		key: node['instana']['agent']['key'],
		host: node['instana']['agent']['endpoint']['host'],
		port: node['instana']['agent']['endpoint']['port'],
		proxy_enabled: node['instana']['agent']['proxy']['enabled'],
		proxy_type: node['instana']['agent']['proxy']['type'],
		proxy_host: node['instana']['agent']['proxy']['host'],
		proxy_port: node['instana']['agent']['proxy']['port'],
		proxy_dns: node['instana']['agent']['proxy']['dns'],
		proxy_username: node['instana']['agent']['proxy']['username'],
		proxy_password: node['instana']['agent']['proxy']['password']
	)
end
