class FakeYammer < Sinatra::Base
  cattr_accessor :successful_hits

  def self.activity_messages_sent
    successful_hits
  end

  def self.reset
    self.successful_hits = 0
  end

  post '/api/v1/activity.json' do
    self.successful_hits += 1
    202
  end
end

ShamRack.mount(FakeYammer, 'www.yammer.com', 443)
