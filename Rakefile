#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |task|
  task.libs << "test"
  task.test_files = Dir["test/**/*_test.rb"] - Dir["test/**/*_slow_test.rb"]
  task.verbose = true
end

Rake::TestTask.new do |task|
  task.name = :slow_test
  task.libs << "test"
  task.test_files = Dir["test/**/*_test.rb"]
  task.verbose = true
end
