SchedDo::Application.configure do
  config.action_controller.perform_caching = false
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.default_url_options = { host: 'scheddo.dev' }
  config.action_mailer.raise_delivery_errors = false
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_support.deprecation = :log
  config.assets.compress = false
  config.assets.debug = true
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.whiny_nils = true
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
