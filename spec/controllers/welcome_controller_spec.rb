require 'spec_helper'

describe WelcomeController, '#index' do
  it 'does not require login' do
    get :index
    should_not deny_access
  end
end
