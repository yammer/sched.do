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
  value.should == expected_value
end
