class FakeYammer < Sinatra::Base
  cattr_accessor :hit_successfully

  def self.has_activity_message?
    hit_successfully
  end

  def self.reset
    self.hit_successfully = false
  end

  post '/api/v1/activity.json' do
    self.hit_successfully = true
    202
  end
end

ShamRack.mount(FakeYammer, 'www.yammer.com', 443)
