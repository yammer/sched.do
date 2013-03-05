require 'spec_helper'

describe Preview, 'event_created_confirmation' do
  it 'sends the email to the correct recipient' do
    event = build_stubbed(:event)
    creator = event.owner

    mail = Preview.new.event_created_confirmation(event)

    expect(mail.to).to eq [creator.email]
  end

  it 'sends the email with the correct subject' do
    event = create(:event)
    creator = event.owner

    mail = Preview.new.event_created_confirmation(event)

    expect(mail.subject).to eq "You created #{event.name} on sched.do"
  end

  it 'sends the email with the correct body' do
    event = create(:event)
    creator = event.owner

    mail = Preview.new.event_created_confirmation(event)

    expect(mail.body.encoded).to include (creator.name)
    expect(mail.body.encoded).to include (event.name)
  end
end

describe Preview, 'invitation' do
  it 'sends the email to the correct recipient' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee

    mail = Preview.new.invitation

    expect(mail.to).to eq [guest.email]
  end

  it 'sends the email with the correct subject' do
    invitation = create(:invitation_with_guest)
    event = invitation.event

    mail = Preview.new.invitation

    expect(mail.subject).to eq "Help out #{event.owner}"
  end

  it 'sends the email with the correct subject' do
    invitation = create(:invitation_with_guest)
    event = invitation.event
    guest = invitation.invitee

    mail = Preview.new.invitation

    expect(mail.body.encoded).to include (guest.name)
  end
end

describe Preview, 'vote_confirmation' do
  it 'sends the email to the correct recipient' do
    vote = create(:vote)
    UserMailer.vote_confirmation(vote)

    mail = Preview.new.vote_confirmation

    expect(mail.to).to eq [vote.voter.email]
  end

  it 'sends the email with the correct subject' do
    vote = create(:vote)
    suggestion = vote.suggestion
    event = suggestion.event
    user_name = vote.voter.name
    UserMailer.vote_confirmation(vote)

    mail = Preview.new.vote_confirmation

    expect(mail.subject).to eq (
      %{Thanks for voting on "#{truncate(event.name, length: 23)}" on sched.do}
    )
  end

  it 'sends the email with the correct body' do
    vote = create(:vote)
    event = vote.event
    user_name = event.owner.name
    event_name = vote.event.name
    UserMailer.vote_confirmation(vote)

    mail = Preview.new.vote_confirmation

    expect(mail.body.encoded).to include(user_name)
    expect(mail.body.encoded).to include(event_name)
  end
end
