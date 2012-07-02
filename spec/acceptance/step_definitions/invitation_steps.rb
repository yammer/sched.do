step 'I invite the Yammer user :user_name to :event_name' do |user_name, event_name|
  user = User.find_by_name!(user_name)
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  click_link 'Edit event or invite people'
  find_field_by_data_role('invitation_name').set(event_name)
  find_field_by_data_role('yammer_user_id').set(user.yammer_user_id)
  click_button 'Update event'
end

step 'I should see :name in the list of invitees' do |name|
  within '#invitees' do
    page.should have_content name
  end
end

step ':guest_email was invited to the event :event_name' do |guest_email, event_name|
  event = Event.find_by_name!(event_name)
  Guest.invite(event, guest_email)
end
