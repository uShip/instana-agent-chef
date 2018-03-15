require 'rspec/core/rake_task'
require 'foodcritic'
require 'stove/rake_task'

FoodCritic::Rake::LintTask.new
RSpec::Core::RakeTask.new(:rspec)
Stove::RakeTask.new(:deploy)

task default: %i[foodcritic]
