step 'I invite the Yammer user :user_name to :event_name' do |user_name, event_name|
  user = User.find_by_name!(user_name)
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  click_link 'Edit event or invite people'
  find_field_by_data_role('invitation_name').set(event_name)
  find_field_by_data_role('yammer_user_id').set(user.yammer_user_id)
  click_button 'Update event'
end

step 'I invite the Yammer group :user_name to :event_name' do |group_name, event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  click_link 'Edit event or invite people'
  find_first_empty_field_by_data_role('invitation_name').set(group_name)
  find_first_empty_field_by_data_role('yammer_group_id').set('12345')
  click_button 'Update event'
end

step 'I invite :email to :event_name' do |email, event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  click_link 'Edit event or invite people'
  find_first_empty_field_by_data_role('invitation_name').set(email)
  click_button 'Update event'
end

step 'I should see :name in the list of invitees' do |name|
  within '#invitees' do
    page.should have_content name
  end
end

step 'I should see :name in the groups list' do |name|
  within '#invitees' do
    page.should_not have_content name
  end

  within '#groups' do
    page.should have_content name
  end
end


step ':guest_email was invited to the event :event_name' do |guest_email, event_name|
  event = Event.find_by_name!(event_name)
  Inviter.new(event).invite_from_params(name_or_email: guest_email)
end

