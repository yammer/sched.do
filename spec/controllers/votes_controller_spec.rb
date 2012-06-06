require 'spec_helper'

describe VotesController, 'authentication' do
  it 'requires login for #create' do
    post :create
    should deny_access
  end
end
