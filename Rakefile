#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be
# available to Rake.

require File.expand_path('../config/application', __FILE__)

SchedDo::Application.load_tasks

begin
  require 'guard/jasmine/task'
  Guard::JasmineTask.new(:jasmine)
rescue LoadError
end

if defined?(RSpec)
  desc 'Run factory specs'
  RSpec::Core::RakeTask.new(:factory_specs) do |t|
    t.pattern = './spec/factories_spec.rb'
  end

  desc 'Run acceptance specs'
  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = 'spec/acceptance/**/*.feature'
  end
end

task spec: :factory_specs
task(:default).clear
task :default => [:spec, :acceptance, 'guard:jasmine']
