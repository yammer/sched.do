step 'I should see :text' do |text|
  expect(page).to have_content text
end

step 'I should see the :text link' do |text|
  expect(page).to have_link(text)
end

step 'I should not see the :text link' do |text|
  expect(page).to_not have_link(text)
end
