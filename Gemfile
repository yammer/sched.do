source 'https://rubygems.org'

ruby '1.9.3'

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
gem 'cocoon'
gem 'flutie'
gem 'bourbon'
gem 'jquery-rails'
gem 'omniauth', '~> 1.0'
gem 'omniauth-oauth2', '~> 1.0.2'
gem 'airbrake', '~> 3.1.0'
gem 'underscore-rails', '~> 1.3.1'

group :development do
  gem 'heroku'
  gem 'bundler', '>= 1.2.0.pre'
  gem 'foreman', '~> 0.46.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.9.0'
  gem 'sham_rack'
  gem 'pry'
  gem 'evergreen', require: 'evergreen/rails'
end

group :test do
  gem 'turnip', '~> 1.0.0'
  gem 'capybara-webkit', '~> 0.12.0'
  gem 'factory_girl_rails', '~> 3.0'
  gem 'bourne'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'shoulda-matchers', '~> 1.1.0'
  gem 'launchy'
  gem 'email_spec'
end

group :staging, :production do
  gem 'sprockets-redirect'
end
