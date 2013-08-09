source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'

gem 'airbrake'
gem 'attr_encrypted'
gem 'aws-sdk', '~> 1.3.9'
gem 'bourbon'
gem 'cocoon'
gem 'delayed_job_active_record'
gem 'formtastic'
gem 'flutie'
gem 'high_voltage'
gem 'hirefireapp'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'newrelic_rpm'
gem 'omniauth-oauth2'
gem 'paperclip'
gem 'pg'
gem 'sass'
gem 'swfobject-rails', github: 'SoftSwiss/swfobject-rails'
gem 'tddium'
gem 'thin'
gem 'yam', '~> 2.0.0'
gem 'zclip-rails'

# Gems used only for assets, not required in production environments by default.
group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'uglifier'
end

group :development do
  gem 'better_errors'                      # Must stay only in development group
  gem 'binding_of_caller'                  # Must stay only in development group
  gem 'bundler'
  gem 'foreman'
  gem 'quiet_assets'
end

group :test do
  gem 'capybara-webkit', '~> 0.14.0'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'jasmine'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'sinatra'
  gem 'timecop'
  gem 'turnip', '1.0'
  gem 'mocha'                              # Must be required last in this group
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv'
  gem 'guard-jasmine', require: false
  gem 'jasminerice', github: 'bradphelan/jasminerice'
  gem 'mail_view'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'sham_rack'
end

group :development, :test, :tddium_ignore do
  gem 'pry'
end

group :staging, :production do
  gem 'sprockets-redirect'
  gem 'rails_12factor'
end
