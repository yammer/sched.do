step "I fill in :field with :value" do |field, value|
  fill_in field, with: value
end

step 'I press :button' do |button|
  click_button button
end
