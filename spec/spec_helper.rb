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
require 'shoulda-matchers'
require 'paperclip/matchers'
require 'email_spec'

Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

Capybara.javascript_driver = :webkit
Capybara.add_selector(:css) do
    xpath { |css| XPath.css(css) }
end

RSpec.configure do |config|
  config.fail_fast = true
  config.include ActionView::Helpers::TextHelper
  config.include Capybara::DSL, type: :request
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include FactoryGirl::Syntax::Default
  config.include Paperclip::Shoulda::Matchers
  config.include DelayedJobSpecHelper
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  URL_HELPERS = Rails.application.routes.url_helpers
end
