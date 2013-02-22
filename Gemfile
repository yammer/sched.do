source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 3.2'

gem 'airbrake', '~> 3.1'
gem 'attr_encrypted'
gem 'aws-sdk', '~> 1.3.4'
gem 'bourbon', '~> 2.1'
gem 'delayed_job_active_record'
gem 'flutie', '= 1.3.3'
gem 'formtastic'
gem 'high_voltage', '~> 1.2'
gem 'hirefireapp'
gem 'jquery-rails'
gem 'newrelic_rpm'
gem 'omniauth-oauth2'
gem 'paperclip'
gem 'pg'
gem 'sass'
gem 'strong_parameters'
gem 'swfobject-rails'
gem 'tddium'
gem 'thin'
gem 'yam'
gem 'zclip-rails'
gem 'cocoon'

# Gems used only for assets, not required in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2'
  gem 'sass-rails', '~> 3.2'
  gem 'uglifier', '>= 1.0'
end

group :development do
  gem 'better_errors'                      # Must stay only in development group
  gem 'binding_of_caller'                  # Must stay only in development group
  gem 'bundler', '>= 1.2.0.pre'
  gem 'foreman', '~> 0.46'
  gem 'quiet_assets'
end

group :test do
  gem 'bourne', require: false
  gem 'capybara-webkit', '~> 0.12.0'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_girl_rails', '~> 3.0'
  gem 'launchy'
  gem 'shoulda-matchers', '~> 1.4'
  gem 'simplecov', require: false
  gem 'sinatra'
  gem 'timecop'
  gem 'turnip', '1.0'
  gem 'mocha'                              # Must be required last in this group
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv'
  gem 'evergreen', require: 'evergreen/rails'
  gem 'mail_view'
  gem 'rspec-rails'
  gem 'sham_rack'
end

group :development, :test, :tddium_ignore do
  gem 'pry'
end

group :staging, :production do
  gem 'sprockets-redirect'
end
