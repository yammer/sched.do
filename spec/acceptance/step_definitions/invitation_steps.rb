# Given / When
step 'I invite the Yammer user :user_name to :event_name' do |user_name, event_name|
  user = User.find_by_name!(user_name)
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  mock_out_yammer_api(name:  user_name, id: user.yammer_user_id, return_type: 'user')
  fill_in_autocomplete(user_name)
  choose_autocomplete('.name', user_name)
end

step 'I invite the new Yammer group :group_name to :event_name by typing :text into the autocomplete' do |group_name, event_name, text|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  mock_out_yammer_api(name: group_name, id: 12345, return_type: 'group')
  fill_in_autocomplete(text)
  choose_autocomplete('.name', group_name)
end

step 'I invite the Yammer group :group_name to :event_name' do |group_name, event_name|
  event = Event.find_by_name!(event_name)
  group = Group.new(name: group_name, yammer_group_id: 12345)
  group.save!
  visit event_path(event)
  mock_out_yammer_api(name: group_name, id: group.yammer_group_id, return_type: 'group')
  fill_in_autocomplete(group_name)
  choose_autocomplete('.name', group_name)
end

step 'I invite myself' do
  user = User.last
  event = Event.last
  visit event_path(event)
  find_field_by_data_role('invitation_name').set(event.name)
  find_field_by_data_role('yammer_user_id').set(user.yammer_user_id)
  click_button 'add-invitee'
end

step 'I invite :email to :event_name via the autocomplete' do |email, event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  mock_out_yammer_api_with_no_response
  fill_in_autocomplete(email)
  choose_autocomplete('.email', email)
end

step 'I invite :emails to :event_name' do |emails, event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  find('#auto-complete').set(emails)
  click_button 'add-invitee'
end

step 'I fill in :name in the invitation field' do |name|
  find_field_by_data_role('invitation_name').set(name)
  click_button 'add-invitee'
end

step 'someone invites :email to :event_name' do |email, event_name|
  event = Event.find_by_name!(event_name)
  invitation = Invitation.new(event: event)
  InviteeBuilder.new.find_user_by_email_or_create_guest(email, event).save
end

step ':guest_email was invited to the event :event_name' do |guest_email, event_name|
  event = Event.find_by_name!(event_name)
  invitation = Invitation.new(event: event)
  InviteeBuilder.new(guest_email, event).find_user_by_email_or_create_guest.save
end

# Multi-invite page
step 'I invite the Yammer user :user_name to :event_name from the multiple invite page' do |user_name, event_name|
  mock_out_yammer_api(name:  user_name, id: 1, return_type: 'user')
  fill_in_autocomplete(user_name)
  choose_autocomplete('.name', user_name)
end

step 'I invite the Yammer group :group_name to :event_name from the multiple invite page' do |group_name, event_name|
  mock_out_yammer_api(name:  group_name, id: 1, return_type: 'group')
  fill_in_autocomplete(group_name)
  choose_autocomplete('.name', group_name)
end

step 'I invite :email to :event_name via the autocomplete from the multiple invite page' do |email, event_name|
  mock_out_yammer_api_with_no_response
  fill_in_autocomplete(email)
  choose_autocomplete('.email', email)
end

# Then
step 'I should see :name in the list of invitees' do |name|
  within '#invitees' do
    page.should have_content name
  end
end

step 'I should not see :group_name in the groups list' do |group_name|
  page.should_not have_content group_name
end

step 'I should not see :name in the list of invitees' do |name|
  within '#invitees' do
    page.should_not have_content name
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

step ':first_item should appear before :second_item' do |first_item, second_item|
  page.body.should =~ /#{first_item}.*#{second_item}/m
end

step ':name should receive a private message' do |name|
  FakeYammer.messages_endpoint_hits.should == 1
end
