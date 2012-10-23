require 'spec_helper'

describe Preview, 'event_created_confirmation' do
  it 'sends the email to the correct recipient' do
    event = create(:event)
    creator = event.owner

    mail = Preview.new.event_created_confirmation(event)

    mail.to.should == [creator.email]
  end

  it 'sends the email with the correct subject' do
    event = create(:event)
    creator = event.owner

    mail = Preview.new.event_created_confirmation(event)

    mail.subject.should == "You created #{event.name} on Sched.do"
  end

  it 'sends the email with the correct body' do
    event = create(:event)
    creator = event.owner

    mail = Preview.new.event_created_confirmation(event)

    mail.body.encoded.should include (creator.name)
    mail.body.encoded.should include (event.name)
  end
end

describe Preview, 'invitation' do
  it 'sends the email to the correct recipient' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee

    mail = Preview.new.invitation

    mail.to.should == [guest.email]
  end

  it 'sends the email with the correct subject' do
    invitation = create(:invitation_with_guest)
    event = invitation.event

    mail = Preview.new.invitation

    mail.subject.should == "Help out #{event.owner}"
  end

  it 'sends the email with the correct subject' do
    invitation = create(:invitation_with_guest)
    event = invitation.event
    guest = invitation.invitee

    mail = Preview.new.invitation

    mail.body.encoded.should include (guest.name)
    mail.body.encoded.should include (event.name)
    mail.body.encoded.should include (event.name)
  end
end

describe Preview, 'vote_confirmation' do
  it 'sends the email to the correct recipient' do
    vote = create(:vote)
    UserMailer.vote_confirmation(vote)

    mail = Preview.new.vote_confirmation

    mail.to.should == [vote.voter.email]
  end

  it 'sends the email with the correct subject' do
    vote = create(:vote)
    suggestion = vote.suggestion
    event = suggestion.event
    user_name = vote.voter.name
    UserMailer.vote_confirmation(vote)

    mail = Preview.new.vote_confirmation

    mail.subject.should ==
      %{Thanks for voting on "#{truncate(event.name, length: 23)}" on Sched.do}
  end

  it 'sends the email with the correct body' do
    vote = create(:vote)
    event = vote.event
    user_name = event.owner.name
    event_name = vote.event.name
    UserMailer.vote_confirmation(vote)

    mail = Preview.new.vote_confirmation

    mail.body.encoded.should include(user_name)
    mail.body.encoded.should include(event_name)
  end
end
