# encoding: utf-8

# instana-agent - Attributes file - defining attributes for the instana-agent
node.default['instana']['agent']['flavor'] = 'full'
node.default['instana']['agent']['agent_key'] = ''
node.default['instana']['agent']['endpoint']['host'] = 'saas-us-west-2.instana.io'
node.default['instana']['agent']['endpoint']['port'] = 443
node.default['instana']['agent']['jdk'] = ''
node.default['instana']['agent']['update']['interval'] = 'DAY' # see template agent-update.erb for intervals
node.default['instana']['agent']['update']['enabled'] = true
node.default['instana']['agent']['update']['time'] = '04:30'
