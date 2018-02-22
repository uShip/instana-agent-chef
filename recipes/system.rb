# encoding: utf-8

#
# Cookbook Name:: instana-agent
# Recipe:: system
#
# Copyright 2017, INSTANA Inc
#

include_recipe 'zypper::default' if node['platform_family'] == 'suse'

systemd_srv_dir = '/etc/systemd/system/instana-agent.service.d'
gpg_path = 'https://packages.instana.io/Instana.gpg'
domain = "https://_:#{node['instana']['agent']['key']}@packages.instana.io"

package 'apt-transport-https' do
	action :install
	only_if { node['platform_family'] == 'debian' }
end

apt_repository 'Instana-Agent' do
	repo_name 'instana-agent'
	distribution 'generic'
	arch 'amd64'
	key gpg_path
	uri "#{domain}/agent"
	components ['main']
	action :add
	only_if { node['platform_family'] == 'debian' }
end

apt_update 'instana-agent' do
	action :update 
	only_if { node['platform_family'] == 'debian' }
end

yum_repository 'Instana-Agent' do
	description 'The Agent repository by Instana, Inc.'
	baseurl "#{domain}/agent/generic/x86_64"
	gpgkey gpg_path
	repo_gpgcheck true
	gpgcheck false
	action %i[create makecache]
	only_if { %w[rhel suse amazon].include? node['platform_family'] }
end

zypper_repo 'Instana-Agent' do
	action :add
	key gpg_path
	uri "#{domain}/agent/generic/x86_64"
	only_if { node['platform_family'] == 'suse' }
end

package 'instana-agent' do
	package_name "instana-agent-#{node['instana']['agent']['flavor']}"
	action :upgrade
end

directory systemd_srv_dir do
	owner 'root'
	group 'root'
	mode '0644'
	action :create
	only_if { node['init_package'] == 'systemd' }
end

template "#{systemd_srv_dir}/10-resources.conf" do
	source 'systemd_resources.erb'
	owner 'root'
	group 'root'
	mode '0644'
	action :create
	variables(
		limit_cpu: node['instana']['agent']['limit']['cpu']['enabled'],
		cpu_quota: node['instana']['agent']['limit']['cpu']['quota'],
		limit_memory: node['instana']['agent']['limit']['memory']['enabled'],
		memory_quota: node['instana']['agent']['limit']['memory']['maxsize']
	)
	only_if do
		node['init_package'] == 'systemd' &&
			(node['instana']['agent']['limit']['cpu']['enabled'] ||
				node['instana']['agent']['limit']['memory']['enabled'])
	end
	notifies :run, "execute[systemd-daemon-reload]"
end

execute "systemd-daemon-reload" do
	action :nothing
	command 'systemctl daemon-reload'
end
