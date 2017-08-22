# encoding: utf-8

#
# Cookbook Name:: instana-agent
# Recipe:: mirrors_config
#
# Copyright 2017, INSTANA Inc
#

template '/opt/instana/agent/etc/mvn-settings.xml' do
  source 'maven_settings.erb'
  mode '0640'
  owner 'root'
  group 'root'
  variables(
    proxy_enabled: node['instana']['agent']['proxy']['enabled'],
    proxy_type: node['instana']['agent']['proxy']['type'],
    proxy_host: node['instana']['agent']['proxy']['host'],
    proxy_port: node['instana']['agent']['proxy']['port'],
    proxy_username: node['instana']['agent']['proxy']['username'],
    proxy_password: node['instana']['agent']['proxy']['password'],
    mirrors_enabled: node['instana']['agent']['mirror']['enabled'],
    mirrors_require_auth: node['instana']['agent']['mirror']['auth']['enabled'],
    mirrors_username: node['instana']['agent']['mirror']['auth']['username'],
    mirrors_password: node['instana']['agent']['mirror']['auth']['password'],
    release_repourl: node['instana']['agent']['mirror']['urls']['release'],
    shared_repourl: node['instana']['agent']['mirror']['urls']['shared']
  )
  only_if do
    node['instana']['agent']['proxy']['enabled'] ||
      node['instana']['agent']['mirror']['enabled']
  end
end
