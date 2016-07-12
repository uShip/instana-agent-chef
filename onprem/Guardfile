# encoding: utf-8
# Copyright 2016, INSTANA Inc (All rights reserved)

guard 'rubocop',
      all_on_start: true,
      notification: false do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch(%r{^test/.+\.rb$})
  watch('metadata.rb')
  watch('Guardfile')
  watch('Gemfile')
end

guard 'foodcritic',
      cookbook_paths: './',
      all_on_start: true,
      notification: false,
      cli: '--epic-fail any' do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
end

guard :rspec,
      cmd: 'bundle exec rspec --color --format documentation',
      all_on_start: true,
      notification: false do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^recipes/(.+)\.rb$})
  watch(%r{^spec/(.+)_spec\.rb$}) { 'spec' }
end
