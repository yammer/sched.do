step 'I should see the :text button' do |text|
  expect(page).to have_button text
end

step 'I should not see the :text button' do |text|
  expect(page).to_not have_button(text)
end

step 'I should see :text' do |text|
  expect(page).to have_content text
end

step 'I should see the :text link' do |text|
  expect(page).to have_link(text)
end

step 'I should not see the :text link' do |text|
  expect(page).to_not have_link(text)
end

step 'the share modal should not be visible' do
  expect(find(:css, '.footer-link')).to_not be_visible
end

step 'the customize message field should contain :text' do |text|
  expect(first(:css, '.customize-message').value).to include(text)
end
