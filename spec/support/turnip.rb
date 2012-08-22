# SimpleCov calculates test coverage on rake. Output at 'coverage/index.html'
require 'simplecov'

# Load Turnip steps.
Dir.glob('spec/acceptance/step_definitions/**/*steps.rb') { |f| load(f, true) }

# Do not run Delayed Jobs during acceptance testing
Delayed::Worker.delay_jobs = false
