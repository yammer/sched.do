require Rails.root.join('lib', 'yammer-strategy')

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :yammer, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
end
