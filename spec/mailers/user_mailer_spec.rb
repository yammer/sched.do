require 'spec_helper'

describe UserMailer do
  it 'uses the correct reply-to address' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_confirmation(vote)

    expect(mail.from).to eq ['no-reply@sched.do']
  end
end

describe UserMailer, '.event_created_confirmation' do
  it 'sends the email to the correct recipient' do
    event = build_stubbed(:event)
    creator = event.owner

    mail = UserMailer.event_created_confirmation(event)

    expect(mail.to).to eq [creator.email]
  end

  it 'sends the email with the correct subject' do
    event = build_stubbed(:event)
    creator = event.owner

    mail = UserMailer.event_created_confirmation(event)

    expect(mail.subject).to eq "You created #{event.name} on sched.do"
  end

  it 'sends the email with the correct body' do
    event = build_stubbed(:event)
    creator = event.owner

    mail = UserMailer.event_created_confirmation(event)

    expect(mail.body.encoded).to include (creator.name)
    expect(mail.body.encoded).to include (event.name)
  end
end

describe UserMailer, '.invitation' do
  it 'sends the email from the correct sender' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee
    event = invitation.event

    mail = UserMailer.invitation(invitation)

    expect(mail['from'].to_s).to eq (
      %{"sched.do" <no-reply@sched.do>}
    )
  end

  it 'sends the email to the correct recipient' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee
    event = invitation.event

    mail = UserMailer.invitation(invitation)

    expect(mail.to).to eq [guest.email]
  end

  it 'sends the email with the correct subject' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee
    event = invitation.event

    mail = UserMailer.invitation(invitation)

    expect(mail.subject).to eq "Help out #{event.owner}"
  end

  it 'sends the email with the correct body when invitees present' do
    invitation = create(:invitation_with_guest)
    guest = invitation.invitee
    event = invitation.event
    first_invitee = event.invitees.first

    mail = UserMailer.invitation(invitation)

    expect(mail.body.encoded).to include(guest.name)
    expect(mail.body.encoded).to include(event.name)
    expect(mail.body.encoded).to include(first_invitee.name)
  end
end

describe UserMailer, '.vote_confirmation' do
  it 'sends the email to the correct recipient' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_confirmation(vote)

    expect(mail.to).to eq [vote.voter.email]
  end

  it 'sends the email with the correct subject' do
    vote = build_stubbed(:vote)
    suggestion = vote.suggestion
    event = suggestion.event
    user_name = vote.voter.name
    mail = UserMailer.vote_confirmation(vote)

    expect(mail.subject).to eq (
      %{Thanks for voting on "#{truncate(event.name, length: 23)}" on sched.do}
    )
  end

  it 'sends the email with the correct body' do
    vote = build_stubbed(:vote)
    event = vote.event
    user_name = event.owner.name
    event_name = vote.event.name

    mail = UserMailer.vote_confirmation(vote)

    expect(mail.body.encoded).to include(user_name)
    expect(mail.body.encoded).to include(event_name)
  end

  it 'includes the last paragraph if the voter is not the poll creator' do
    vote = build_stubbed(:vote)
    voter = build_stubbed(:user)
    vote.voter = voter
    mail = UserMailer.vote_confirmation(vote)

    expect(mail.body.encoded).to include 'Did you know you can send your own polls for free?'
  end

  it 'omits the last paragraph if the voter is the poll creator' do
    vote = build_stubbed(:vote)
    vote.voter = vote.event.owner
    mail = UserMailer.vote_confirmation(vote)

    expect(mail.body.encoded).to_not include 'Did you know you can send your own polls for free?'
  end
end

describe UserMailer, 'vote_notification' do
  it 'sends the email to the correct recipient' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_notification(vote)

    expect(mail.to).to eq [vote.event.owner.email]
  end

  it 'sends the email with the correct subject' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_notification(vote)

    expect(mail.subject).to eq (
      %{#{vote.voter.name} voted on "#{truncate(vote.suggestion.event.name, length: 23)}" on sched.do}
    )
  end

  it 'sends the email with the correct body' do
    vote = build_stubbed(:vote)

    mail = UserMailer.vote_notification(vote)

    expect(mail.body.encoded).to include(vote.voter.name)
    expect(mail.body.encoded).to include(vote.event.name)
  end
end

describe UserMailer, '.reminder' do
  it 'sends the email to the correct receipient' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)

    mail = UserMailer.reminder(invitation, sender)

    expect(mail.to).to eq [invitation.invitee.email]
  end

  it 'send the email from the correct email address' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)

    mail = UserMailer.reminder(invitation, sender)

    expect(mail.from).to eq ['no-reply@sched.do']
  end

  it 'sends the email with the correct subject' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)

    mail = UserMailer.reminder(invitation, sender)

    expect(mail.subject).to eq (
      "Reminder: Help out #{sender.name} by voting on #{invitation.event.name}"
    )
  end

  it 'sends the email with the correct body' do
    invitation = build_stubbed(:invitation)
    sender = build_stubbed(:user)

    mail = UserMailer.reminder(invitation, sender)

    expect(mail.body.encoded).to include(sender.name)
    expect(mail.body.encoded).to include(invitation.event.name)
    expect(mail.body.encoded).to_not include(invitation.event.owner.name)
  end
end
