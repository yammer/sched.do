step 'I share the sched.do application' do
  mock_out_yammer_api({name: 'Laila', id: 12345, return_type: 'user' })
  click_button 'Share'
end

step 'I share the sched.do app and get an error from the Yammer API' do
  mock_failed_yam_request
  click_button 'Share'
end

step 'I close the share sched.do modal' do
  first(:css, '.ui-dialog-titlebar-close').click
end

step 'I choose to share sched.do with the Yammer group :group_name' do |group_name|
  mock_out_yammer_api(name: group_name, id: 1, return_type: 'group')
  fill_in_autocomplete(group_name, '.share-app')
  choose_autocomplete('.name', group_name, '.share-app')
end

step 'I should see :group_name in the share event dialog groups list' do |group_name|
  within first('.share-app') do
    expect(page).to have_content group_name
  end
end

step 'I expand the Group list' do
  find('.group-list').click
end

step ':group_name should be included in the list' do |group_name|
  within('.group-list') do
    expect(page).to have_content group_name
  end
end

step 'a group exists named :group_name' do |group_name|
  group = create(:group, name: group_name)
  mock_out_get_groups(
    name: group_name,
    id: group.id,
    return_type: 'group'
  )
end

step 'I select :group_name from the group list' do |group_name|
  group = Group.find_by_name(group_name)
  find("[data-group-id=\"#{group.id}\"]").click();
end

step 'there should be :count options in the group list' do |count|
  within first('.group-list') do
    expect(page).to have_css('.group', count: count)
  end
end
