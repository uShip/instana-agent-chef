# encoding: utf-8

#
# Cookbook Name:: instana-agent
# Recipe:: agent_config
#
# Copyright 2017, INSTANA Inc
#

template "#{node['instana']['agent']['config_dir']}/configuration.yaml" do
	source 'agent_config.erb'
	mode '0640'
	owner 'root'
	group 'root'
	variables(
		zone: node['instana']['agent']['zone'],
		tags: node['instana']['agent']['tags']
	)
end
