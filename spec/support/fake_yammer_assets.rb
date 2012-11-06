# Fakes out the yam.js asset loading to use a local copy

class FakeYammerAssets < Sinatra::Base
  def self.boot
    instance = new
    Capybara::Server.new(instance).tap { |server| server.boot }
  end

  get '/platform/yam.js' do
    content_type 'application/x-javascript'
    IO.read("#{Rails.root}/spec/support/fake_yammer_assets/yam.js")
  end
end

server = FakeYammerAssets.boot

YAMMER_ASSETS_HOST = "http://"  + [server.host, server.port].join(':')
YAMMER_ASSETS_STAGING_HOST = "http://" + [server.host, server.port].join(':')
