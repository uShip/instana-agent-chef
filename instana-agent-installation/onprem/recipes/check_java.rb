#
# Cookbook Name:: instana-agent-onprem
# Recipe:: check_java
#
# Copyright 2016, 2016 Instana, Inc.
#
# All rights reserved - Do Not Redistribute
#

jloc = ''
if node.default.key?('javaloc')
  jloc = node.default['javaloc']
elsif ENV.key?('JAVA_HOME')
  jloc = ENV['JAVA_HOME']
end

has_java = (jloc != '' && File.directory?(jloc))
is_jdk = File.exist?("#{jloc}/lib/tools.jar")

log 'no java found' do
  message 'No version of java could be detected. Please make sure you define ' \
    'a path in the attributes section.'
  level :warn
  not_if { has_java }
end

log 'unsupported version of java' do
  message 'You seem to be running an unsupported version of java. Please make' \
    'sure you\'re running the Oracle JDK with Java 8.'
  level :warn
  not_if { has_java && is_jdk }
end
