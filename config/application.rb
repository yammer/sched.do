# Set global hostnames
YAMMER_HOST = 'https://www.yammer.com'
YAMMER_ENDPOINT = YAMMER_HOST + '/api/v1/'
YAMMER_STAGING_HOST = 'https://www.staging.yammer.com'
YAMMER_STAGING_ENDPOINT = YAMMER_STAGING_HOST + '/api/v1/'

require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"

if defined?(Bundler)
  Bundler.require(:default, :assets, Rails.env)
end

module SchedDo
  class Application < Rails::Application
    config.generators do |generate|
      generate.test_framework :rspec
    end

    config.active_record.whitelist_attributes = false
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w(media-queries.css ie.css)
    config.assets.version = '1.3'
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end
end
