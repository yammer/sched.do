step 'I invite the Yammer user :user_name to :event_name' do |user_name, event_name|
  user = User.find_by_name!(user_name)
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  find_field_by_data_role('invitation_name').set(event_name)
  find_field_by_data_role('yammer_user_id').set(user.yammer_user_id)
  click_button 'add-invitee'
end

step 'I invite the Yammer group :user_name to :event_name' do |group_name, event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  find_first_empty_field_by_data_role('invitation_name').set(group_name)
  find_first_empty_field_by_data_role('yammer_group_id').set('12345')
  click_button 'add-invitee'
end

step 'I invite myself' do
  user = User.last
  event = Event.last
  visit event_path(event)
  find_field_by_data_role('invitation_name').set(event.name)
  find_field_by_data_role('yammer_user_id').set(user.yammer_user_id)
  click_button 'add-invitee'
end

step 'I invite :email to :event_name' do |email, event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
  find_first_empty_field_by_data_role('invitation_name').set(email)
  click_button 'add-invitee'
end

step 'I fill in :name in the invitation field' do |name|
  find_field_by_data_role('invitation_name').set(name)
  click_button 'add-invitee'
end

step 'someone invites :email to :event_name' do |email, event_name|
  event = Event.find_by_name!(event_name)
  invitation = Invitation.new(event: event)
  invitation.build_invitee(name_or_email: email).save
end

step 'I should see :name in the list of invitees' do |name|
  within '#invitees' do
    page.should have_content name
  end
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

step ':guest_email was invited to the event :event_name' do |guest_email, event_name|
  event = Event.find_by_name!(event_name)
  invitation = Invitation.new(event: event)
  invitation.build_invitee(name_or_email: guest_email).save
end

step ':first_item should appear before :second_item' do |first_item, second_item|
  page.body.should =~ /#{first_item}.*#{second_item}/m
end

step ':name should receive a private message' do |name|
  FakeYammer.messages_endpoint_hits.should == 1
end
