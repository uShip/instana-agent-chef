# encoding: utf-8
# instana-agent - Unittest file - tests for the check_java recipe

require 'rspec'
require 'chefspec'
require 'fileutils'
at_exit { ChefSpec::Coverage.report! }

# RSpec.configure do |config|
#   # Specify the Chef log_level (default: :warn)
#   config.log_level = :debug
# end

describe 'instana-agent::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge described_recipe }
  let(:mocked_jpath) { '/opt/oraclejdkdir1.8blafoo' }
  let(:no_java_found) do
    'No version of java could be detected. Please make sure you ' \
      'define a path in the attributes section.'
  end
  let(:no_jdk) do
    'You seem to be running an unsupported version of java. Please make' \
      'sure you\'re running the Oracle JDK with Java 8.'
  end

  before do
    Dir.mkdir('/tmp/lib') unless Dir.exist?('/tmp/lib')
  end

  context 'No java found log message' do
    context 'without java' do
      before do
        ENV.clear
      end
      it 'logs an error if no java could be detected' do
        expect(chef_run).to write_log(no_java_found)
      end
    end
    context 'with stubbed java via environment variable' do
      before do
        ENV['JAVA_HOME'] = mocked_jpath
      end
      it 'detects an installed version of java' do
        expect(chef_run).to_not write_log(no_java_found)
      end
    end
    context 'with stubbed java via attribute' do
      let(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.default['javaloc'] = mocked_jpath
        end.converge(described_recipe)
      end
      it 'detects an installed version of java' do
        expect(chef_run).to_not write_log(no_java_found)
      end
    end
  end
  context 'No JDK error message' do
    context 'not found' do
      before do
        File.delete('/tmp/lib/tools.jar') if File.exist?('/tmp/lib/tools.jar')
        ENV['JAVA_HOME'] = '/'
      end
      it 'logs an error if java is not a JDK installation' do
        expect(chef_run).to write_log(no_jdk)
      end
    end
    context 'mocked' do
      before do
        FileUtils.touch('/tmp/lib/tools.jar')
        ENV['JAVA_HOME'] = '/tmp'
      end
      it 'detects JAVA_HOME/lib/tools.jar' do
        expect(chef_run).to_not write_log(no_jdk)
      end
    end
  end
end
