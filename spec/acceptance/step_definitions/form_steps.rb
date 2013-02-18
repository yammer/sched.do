step "I fill in :field with :value" do |field, value|
  fill_in field, with: value
end

step 'I press :button' do |button|
  click_button button
end

step "I should see :field filled in with :value" do |field, expected_value|
  value = begin
    find_field(field).value
  rescue Capybara::ElementNotFound
    find("input[@placeholder='#{field}']").value
  end
  expect(value).to eq expected_value
end

step 'I should see :error under the title' do |error|
  expect(find('#event_name + p')).to have_content(error)
end

step 'I should see :error under the first suggestion' do |error|
  expect(find('#event_primary_suggestions_attributes_0_description + p')
        ).to have_content(error)
end
