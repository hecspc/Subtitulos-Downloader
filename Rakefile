require "bundler/gem_tasks"
require 'bundler/setup'
require 'rspec/core/rake_task'

Bundler.setup(:default, :development)


desc "Run all RSpec tests"
RSpec::Core::RakeTask.new(:spec)

desc "Build the gem"
task :gem do
  sh 'gem build *.gemspec'
end

task :default => :spec
