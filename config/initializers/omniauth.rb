require Rails.root.join('lib', 'yammer-strategy')
require Rails.root.join('lib', 'yammer-staging-strategy')

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :yammer, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  provider :yammer_staging, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
end
