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

Rails.configuration.yammer_assets_host = "http://"  + [server.host, server.port].join(':')
Rails.configuration.yammer_assets_staging_host = "http://"  + [server.host, server.port].join(':')
