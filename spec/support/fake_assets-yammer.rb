class FakeAssetsYammer < Sinatra::Base
  MUG_DOMAIN = 'mug0.assets-yammer.com'

  get '/*' do
    "https://#{MUG_DOMAIN}/mugshot/images/48x48/-vVkmk83gqGLFBbk2pBvdxJpBcQPCkRj"
  end
end

ShamRack.mount(FakeAssetsYammer, FakeAssetsYammer::MUG_DOMAIN, 443)
