class FakeYammer < Sinatra::Base
  cattr_accessor :activity_endpoint_hits
  cattr_accessor :message
  cattr_accessor :messages_endpoint_hits

  def self.reset
    self.activity_endpoint_hits = 0
    self.messages_endpoint_hits = 0
  end

  post '/api/v1/activity.json' do
    self.activity_endpoint_hits += 1
    202
  end

  post '/api/v1/messages.json' do
    self.messages_endpoint_hits += 1
    self.message = params[:body]
    202
  end
end

ShamRack.mount(FakeYammer, 'www.yammer.com', 443)
