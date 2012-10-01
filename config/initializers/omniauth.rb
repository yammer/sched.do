require Rails.root.join('lib', 'yammer-staging-strategy')
OmniAuth.config.on_failure = SessionsController.action(:oauth_failure)
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :yammer, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  provider :yammer_staging, ENV['STAGING_CONSUMER_KEY'], ENV['STAGING_CONSUMER_SECRET']
end
