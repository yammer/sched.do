source 'https://rubygems.org'

ruby "1.9.3"

gem 'rails', '3.2.3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'pg'
gem 'thin'
gem 'sass'
gem 'high_voltage'
gem 'paperclip', '~> 3.0.4'
gem 'formtastic'
gem 'flutie'
gem 'bourbon'

group :development do
  gem 'heroku'
  gem 'bundler', '>= 1.2.0.pre'
end

group :development, :test do
  gem "rspec-rails", "~> 2.9.0"
  gem "sham_rack"
end

group :test do
  gem 'turnip', '~> 0.3.1'
  gem "capybara-webkit", "~> 0.12.0"
  gem "factory_girl_rails"
  gem "bourne"
  gem "database_cleaner"
  gem "timecop"
  gem "shoulda-matchers"
  gem "launchy"
  gem "email_spec"
end

group :staging, :production do
  gem 'sprockets-redirect'
end
