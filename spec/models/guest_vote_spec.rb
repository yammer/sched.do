require 'spec_helper'

describe GuestVote do
  it { should have_one(:vote) }
  it { should validate_presence_of(:guest_id) }
end

describe GuestVote, '#create' do
  it 'sends confirmation email to guest' do
    mailer = stub('mailer', deliver: true)
    GuestMailer.stubs(vote_confirmation: mailer)
    guest_vote = create(:guest_vote)
    GuestMailer.should have_received(:vote_confirmation).with(guest_vote)
    mailer.should have_received(:deliver).once
  end
end
