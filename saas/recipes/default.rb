# encoding: utf-8
#
# Cookbook Name:: instana-agent
# Recipe:: default
#
# Copyright 2016, INSTANA Inc (All rights reserved)
#

include_recipe 'instana-agent::check_java'
include_recipe 'instana-agent::download'
include_recipe 'instana-agent::install'
