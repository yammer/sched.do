require Rails.root.join('lib', 'yammer-staging-strategy')
OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :yammer, ENV['YAMMER_CONSUMER_KEY'], ENV['YAMMER_CONSUMER_SECRET']
  provider :yammer_staging, ENV['YAMMER_STAGING_CONSUMER_KEY'],
    ENV['YAMMER_STAGING_CONSUMER_SECRET']
end
