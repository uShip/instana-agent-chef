# encoding: utf-8
# instana-agent-onprem - Attributes file
node.default['instana']['endpoint']['url'] = 'https://192.168.0.1/'
node.default['instana']['endpoint']['email'] = 'email@example.com'
node.default['instana']['endpoint']['password'] = 'password'
node.default['instana']['endpoint']['tenant'] = 'acmeinc'
node.default['instana']['endpoint']['unit'] = 'acmeinc'
node.default['instana']['agent']['architecture'] = 64
# node.default['instana']['agent']['architecture'] = 32
node.default['instana']['agent']['os'] = 'linux'
# node.default['instana']['agent']['os'] = 'windows'
# node.default['instana']['agent']['os'] = 'mac'
node.default['instana']['agent']['dest_path'] = '/opt'
node.default['instana']['system_service']['enable'] = true
node.default['instana']['system_service']['start'] = true
node.default['javaloc'] = '/usr/lib/jvm/jdk1.8.0_92'
