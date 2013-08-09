step "I fill in :field with :value" do |field, value|
  fill_in field, with: value
end

step 'I press :button' do |button|
  first(:button, button).click
end

step 'I should see :field filled in with :value' do |field, expected_value|
  value = begin
    find_field(field).value
  rescue Capybara::ElementNotFound
    find("input[@placeholder='#{field}']").value
  end
  expect(value).to eq expected_value
end

step 'I fill in the multiple invite invitation text field with :text' do |text|
  fill_in 'multiple-invite-text', with: text
end

step 'I fill in the Invitation text field with :text' do |text|
  fill_in 'invitation[invitation_text]', with: text
end

step 'I go to invite another person to the event' do
  find_field('invitation[invitee_attributes][name_or_email]').click
end

step 'I should see :text in the Invitation text field' do |text|
  expect(find_field('invitation[invitation_text]').value).to eq text
end

step 'I should see :error under the title' do |error|
  expect(find('#event_name + p')).to have_content(error)
end

step 'I should see :error under the first suggestion' do |error|
  expect(find('#event_primary_suggestions_attributes_0_description')
        ).to have_content(error)
end
