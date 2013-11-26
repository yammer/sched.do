SchedDo::Application.configure do
  config.action_controller.perform_caching = true
  config.action_mailer.asset_host = 'staging.sched.do'
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.assets.compress = true
  config.assets.digest = true
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.i18n.fallbacks = true
  config.serve_static_assets = false
  config.action_mailer.default_url_options = {
    :host => 'staging.sched.do',
    :protocol => 'http'
  }

  ActionMailer::Base.smtp_settings = {
    address:        'smtp.sendgrid.net',
    port:           '587',
    authentication: :plain,
    user_name:      ENV['SENDGRID_USERNAME'],
    password:       ENV['SENDGRID_PASSWORD'],
    domain:         'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp

  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      bucket: ENV['AWS_BUCKET'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    path: '/:class/avatars/:id_:basename.:style.:extension',
    url: ':s3_domain_url'
  }
end
