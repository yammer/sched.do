require 'spec_helper'

describe Messenger, '#invite' do
  it 'send an invitation email' do
    invitation = build_stubbed(:invitation)
    UserMailer.
      stubs(:invitation).
      returns(mock('invitation email', :deliver))

    Messenger.new(invitation).invite

    UserMailer.should have_received(:invitation).with(invitation)
  end
end

describe Messenger, '#remind' do
  it 'sends a reminder email' do
    invitation = build_stubbed(:invitation)
    user = build_stubbed(:user)
    UserMailer.stubs(:reminder).
      returns(mock('reminder email', :deliver))

    Messenger.new(invitation, user).remind

    UserMailer.should have_received(:reminder).with(invitation, user)
  end
end
