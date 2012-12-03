# Calculates test coverage on rake. Output in 'coverage/index.html'
require 'simplecov'

SimpleCov.start do
  add_filter '/support/'
  add_filter '/initializers/'
  add_filter '/lib/'
end

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'turnip/capybara'
require 'email_spec'
require 'bourne'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.mock_with :mocha

  config.include FactoryGirl::Syntax::Default
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include ActionView::Helpers::TextHelper
  config.include DelayedJob::Matchers

  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  Delayed::Worker.delay_jobs = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(type: :request) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Dotenv.load
    Delayed::Worker.delay_jobs = false
  end

  config.after(type: :request) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
    FakeYammer.reset
    GC.disable
  end

  config.after(:each) do
    DatabaseCleaner.clean
    garbage_collect_once_per_second_for_faster_tests
  end

  def garbage_collect_once_per_second_for_faster_tests
    if time_to_run_gc?
      GC.enable
      GC.start
      last_gc_run = Time.now
    end
  end

  def time_to_run_gc?
    (Time.now - last_gc_run) > 1.0
  end

  def last_gc_run=(time)
    @last_run = time
  end

  def last_gc_run
    @last_run ||= Time.now
  end
end
