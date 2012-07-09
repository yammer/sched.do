# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'turnip/capybara'
require 'email_spec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :webkit
DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.mock_with :mocha
  config.include FactoryGirl::Syntax::Default
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Clean before acceptance tests are run, otherwise JS scenarios leave records
  # in the database.
  config.before(:each, type: :request) do
    DatabaseCleaner.clean
    ActionMailer::Base.deliveries.clear
  end



  # if defined?(ActionMailer)
  #   unless [:test, :activerecord, :cache, :file].include?(ActionMailer::Base.delivery_method)
  #     ActionMailer::Base.register_observer(EmailSpec::TestObserver)
  #   end
  #   ActionMailer::Base.perform_deliveries = true

  #   Before do
  #     # Scenario setup
  #     case ActionMailer::Base.delivery_method
  #       when :test then ActionMailer::Base.deliveries.clear
  #       when :cache then ActionMailer::Base.clear_cache
  #     end
  #   end
  # end

  # After do
  #   EmailSpec::EmailViewer.save_and_open_all_raw_emails if ENV['SHOW_EMAILS']
  #   EmailSpec::EmailViewer.save_and_open_all_html_emails if ENV['SHOW_HTML_EMAILS']
  #   EmailSpec::EmailViewer.save_and_open_all_text_emails if ENV['SHOW_TEXT_EMAILS']
  # end
end
