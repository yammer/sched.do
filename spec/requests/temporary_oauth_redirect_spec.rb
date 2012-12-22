require 'spec_helper'

describe 'root url with auth=yammer' do
  it 'redirects to oauth callback' do
    get '/?auth=yammer&code=abc'

    response.should redirect_to('/auth/yammer/callback?code=abc')
  end
end
