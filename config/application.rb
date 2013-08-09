require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, :assets, Rails.env)


module SchedDo
  class Application < Rails::Application
    config.generators do |generate|
      generate.test_framework :rspec
    end

    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w(media-queries.css ie.css *.js)
    config.assets.version = '1.4'
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]

    # Set wait time for share modal after vote
    config.share_app_delay = 45000

    # Set yammer hostnames
    config.yammer_assets_host = 'https://assets.yammer.com'
    config.yammer_assets_staging_host = 'https://assets.staging.yammer.com'
    config.yammer_host = 'https://www.yammer.com'
    config.yammer_staging_host = 'https://www.staging.yammer.com'
  end
end
