# SimpleCov calculates test coverage on rake. Output at 'coverage/index.html'
require 'simplecov'

# Load Turnip steps.
Dir.glob('spec/acceptance/step_definitions/**/*steps.rb') { |f| load(f, true) }
