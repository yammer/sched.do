require 'spec_helper'

describe VotesController, 'authentication' do
  it 'requires yammer or guest login for #create' do
    post :create
    expect(page).to redirect_to(new_guest_url)
  end

  context 'when event is closed' do
    it 'throws an error' do
      user = create(:user)
      event = create(:event, open: false)
      suggestion = event.primary_suggestions.first
      vote_params = {
        event_id: event.id,
        suggestion_id: suggestion.id
      }
      sign_in_as(user)

      xhr :post, :create, vote: vote_params

      expect(response).to be_forbidden
    end
  end
end
