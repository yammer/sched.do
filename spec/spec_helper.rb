# SimpleCov calculates test coverage on rake. Output at 'coverage/index.html'
require 'simplecov'

# Start SimpleCov and exclude directories
SimpleCov.start do
  add_filter "/support/"
  add_filter "/initializers/"
  add_filter "/lib/"
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'turnip/capybara'
require 'email_spec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Capybara-webkit
Capybara.javascript_driver = :webkit

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.mock_with :mocha
  config.include FactoryGirl::Syntax::Default
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include ActionView::Helpers::TextHelper
  config.include DelayedJob::Matchers

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Delay some jobs under Rspec
  Delayed::Worker.delay_jobs = true

  # Acceptance tests before block
  config.before(:each, type: :request) do
    # Clean before are run, otherwise JS scenarios leave records in the database.
    DatabaseCleaner.clean
    ActionMailer::Base.deliveries.clear
    Dotenv.load
    # Do not run Delayed Jobs during acceptance testing
    Delayed::Worker.delay_jobs = false
  end

  # Unit tests before block
  config.before(:each) do
    FakeYammer.reset
  end

  # Unit tests after block
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
