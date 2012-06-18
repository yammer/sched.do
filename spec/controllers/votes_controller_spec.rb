require 'spec_helper'

describe VotesController, 'authentication' do
  it 'requires yammer or guest login for #create' do
    post :create
    should redirect_to(new_guest_url)
  end
end
