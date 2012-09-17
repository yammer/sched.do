require 'spec_helper'

describe RemindersController, '#create' do
  it 'finds an Event' do
    user = create(:user)
    sign_in_as(user)
    Event.stubs(:find_by_uuid!).returns(Event.new)

    post :create, { event_id: 5 }

    Event.should have_received(:find_by_uuid!).with("5").once
  end

  it 'sends a reminder message to all models passed in the collection' do
    user = create(:user)
    sign_in_as(user)

    guest = create(:guest)
    user = create(:user)
    event = create_event_with_invitees(guest, user)
    Event.stubs(find_by_uuid!: event)

    post :create

    guest.should have_received(:deliver_email_or_private_message).once
    user.should have_received(:deliver_email_or_private_message).once
  end

  def create_event_with_invitees(guest, user)
    event = create(:event)

    guest.stubs(:deliver_email_or_private_message)
    user.stubs(:deliver_email_or_private_message)

    event.users << user
    event.guests << guest

    event
  end
end
