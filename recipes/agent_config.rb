# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: agent_config
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

template '/opt/instana/agent/etc/instana/configuration.yaml' do
  source 'agent_config.erb'
  mode '0644'
  owner node['instana']['agent']['user']
  group node['instana']['agent']['group']
  only_if do
    node['instana']['agent']['zone'].empty? ||
      node['instana']['agent']['tags'].empty?
  end
  variables(
    zone: node['instana']['agent']['zone'],
    tags: node['instana']['agent']['tags']
  )
end
