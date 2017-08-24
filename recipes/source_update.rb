# encoding: utf-8

#
# Cookbook Name:: instana-agent
# Recipe:: source_update
#
# Copyright 2017, INSTANA Inc
#

template "#{node['instana']['agent']['config_dir']}/com.instana.agent.main.config.UpdateManager.cfg" do
	source 'agent_update.erb'
	mode '0640'
	owner 'root'
	group 'root'
	action :create
	variables(
		interval: node['instana']['agent']['update']['interval'],
		enabled: (node['instana']['agent']['update']['enabled'] ? 'AUTO' : 'OFF'),
		time: node['instana']['agent']['update']['time']
	)
	only_if do
		node['instana']['agent']['update']['pin'] == '' &&
			node['instana']['agent']['update']['enabled']
	end
end

template "#{node['instana']['agent']['config_dir']}/com.instana.agent.bootstrap.AgentBootstrap.cfg" do
	source 'agent_bootstrap.erb'
	mode '0640'
	owner 'root'
	group 'root'
	action :create
	variables(
		version: node['instana']['agent']['update']['pin']
	)
end
