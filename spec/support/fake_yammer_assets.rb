class FakeYammerAssets < Sinatra::Base
  def self.boot
    instance = new
    Capybara::Server.new(instance).tap { |server| server.boot }
  end

  get '/assets/platform_js_sdk.js' do
    content_type 'application/x-javascript'
    IO.read("#{Rails.root}/spec/support/fake_yammer_assets/platform_js_sdk.js")
  end
end

server = FakeYammerAssets.boot

Rails.configuration.yammer_assets_host = "http://"  + [server.host, server.port].join(':')
Rails.configuration.yammer_assets_staging_host = "http://"  + [server.host, server.port].join(':')
