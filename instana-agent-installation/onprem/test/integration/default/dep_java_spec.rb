# encoding: utf-8
# author: Stefan Staudenmeyer

control 'JAVA location' do
  impact 0.2
  desc 'Check which location java got installed to'
  exec_out = command('which java')
  describe exec_out do
    its('exit_status') { should eq 0 }
    its('stdout') { should eq "/usr/bin/java\n" }
  end
end

control 'JAVA symlink' do
  impact 0.2
  desc 'Check if java is properly symlinked'
  exec_out = file('/usr/lib/jvm/java/lib/tools.jar')
  describe exec_out do
    it { should be_file }
    it { should_not be_executable }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end

control 'JAVA version' do
  impact 0.3
  desc 'Check the java -version output for errors in execution'
  exec_out = command('java -version')
  describe exec_out do
    its('exit_status') { should eq 0 }
    its('stdout') { should eq '' }
    its('stderr') { should include 'version "1.8' }
    its('stderr') { should include 'Java(TM) SE Runtime Environment' }
    its('stderr') { should include '64-Bit Server VM' }
  end
end
