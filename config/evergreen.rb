require 'capybara-webkit'

Evergreen.configure do |config|
  config.driver = :webkit
  config.public_dir = 'app/assets/javascripts'
end
