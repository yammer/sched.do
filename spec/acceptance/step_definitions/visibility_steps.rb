step 'I should see :text' do |text|
  expect(page).to have_content text
end
