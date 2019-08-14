#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2019, INSTANA Inc

# directory 'C:/ProgramData' do
#   rights :full_control, 'Vagrant', applies_to_children: true
# end

instana_agent 'static' do
  key node['instana']['agent']['key']
end
