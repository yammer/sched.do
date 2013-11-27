require 'spec_helper'

describe Messenger, '#invite' do
  it 'send an invitation email' do
    invitation = build_stubbed(:invitation)
    invitation_email = double(deliver: nil)
    UserMailer.stub(invitation: invitation_email)

    Messenger.new(invitation.invitee).invite(invitation)

    expect(UserMailer).to have_received(:invitation).with(invitation)
  end
end

describe Messenger, '#remind' do
  it 'sends a reminder email' do
    event = build(:event)
    recipient = build(:user)
    reminder_email = double(deliver: nil)
    UserMailer.stub(reminder: reminder_email)

    Messenger.new(recipient).remind(event, event.owner)

    expect(UserMailer).to have_received(:reminder).
      with(recipient, event.owner, event)
  end
end

describe Messenger, '#notify' do
  it 'send a winner notification email' do
    event = build(:event)
    recipient = build(:user)
    message = 'Hello world'
    notification_email = double(deliver: nil)
    UserMailer.stub(winner_notification: notification_email)

    Messenger.new(recipient).notify(event, message)

    expect(UserMailer).to have_received(:winner_notification).
      with(recipient, event, message)
  end
end
