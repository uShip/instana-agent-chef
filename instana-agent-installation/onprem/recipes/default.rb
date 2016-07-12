#
# Cookbook Name:: instana-agent-onprem
# Recipe:: default
#
# Copyright 2016, 2016 Instana, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'instana-agent-onprem::check_java'
include_recipe 'instana-agent-onprem::download'
include_recipe 'instana-agent-onprem::install'
include_recipe 'instana-agent-onprem::run'
