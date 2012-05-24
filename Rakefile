#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

SchedDo::Application.load_tasks

if defined?(RSpec)
  desc "Run acceptance specs"
  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = 'spec/acceptance/**/*.feature'
  end
end


task(:default).clear
task :default => [:spec, :acceptance]
