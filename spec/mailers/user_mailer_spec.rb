require 'spec_helper'

describe UserMailer do
  it 'uses the correct reply-to address' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_confirmation(vote)

    mail.from.should == ['no-reply@sched.do']
  end
end

describe UserMailer, 'event_created_confirmation' do
  it 'sends the email to the correct recipient' do
    event = build_stubbed(:event)
    creator = event.user

    mail = UserMailer.event_created_confirmation(event)

    mail.to.should == [creator.email]
  end

  it 'sends the email with the correct subject' do
    event = build_stubbed(:event)
    creator = event.user

    mail = UserMailer.event_created_confirmation(event)

    mail.subject.should == "You created #{event.name} on Sched.do"
  end

  it 'sends the email with the correct body' do
    event = build_stubbed(:event)
    creator = event.user

    mail = UserMailer.event_created_confirmation(event)

    mail.body.encoded.should include (creator.name)
    mail.body.encoded.should include (event.name)
  end
end

describe UserMailer, 'invitation' do
  it 'sends the email to the correct recipient' do
    guest = build_stubbed(:guest)
    event = build_stubbed(:event)

    mail = UserMailer.invitation(guest, event)

    mail.to.should == [guest.email]
  end

  it 'sends the email with the correct subject' do
    guest = build_stubbed(:guest)
    event = build_stubbed(:event)

    mail = UserMailer.invitation(guest, event)

    mail.subject.should == 'You have been invited to a Sched.do event!'
  end

  it 'sends the email with the correct body when invitees present' do
    guest = build_stubbed(:guest)
    event = create(:event_with_invitees)
    first_invitee = event.invitees.first

    mail = UserMailer.invitation(guest, event)

    mail.body.encoded.should include(guest.name)
    mail.body.encoded.should include(event.name)
    mail.body.encoded.should include(first_invitee.name)
  end
end

describe UserMailer, 'vote_confirmation' do
  it 'sends the email to the correct recipient' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_confirmation(vote)

    mail.to.should == [vote.voter.email]
  end

  it 'sends the email with the correct subject' do
    vote = build_stubbed(:vote)
    suggestion = vote.suggestion
    event = suggestion.event
    user_name = vote.voter.name

    mail = UserMailer.vote_confirmation(vote)

    mail.subject.should ==
      %{Thanks for voting on "#{truncate(event.name, length: 23)}" on Sched.do}
  end

  it 'sends the email with the correct body' do
    vote = build_stubbed(:vote)
    event = vote.event
    user_name = event.user.name
    event_name = vote.event.name

    mail = UserMailer.vote_confirmation(vote)

    mail.body.encoded.should include(user_name)
    mail.body.encoded.should include(event_name)
  end
end
