SchedDo::Application.configure do
  config.action_controller.allow_forgery_protection    = false
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_mailer.default_url_options = { :host => 'www.example.com' }
  config.action_mailer.delivery_method = :test
  config.active_record.mass_assignment_sanitizer = :strict
  config.active_support.deprecation = :stderr
  config.cache_classes = true
  config.consider_all_requests_local = true
  config.serve_static_assets = true
  config.share_app_delay = 0
  config.static_cache_control = "public, max-age=3600"
  config.whiny_nils = true
end
