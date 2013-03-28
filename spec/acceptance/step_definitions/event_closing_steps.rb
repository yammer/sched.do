step 'I close the poll' do
  find('.close-button').click
end

step 'I should not be able to close the poll' do
  expect(page).not_to have_css('.close-button')
end

step 'I should see a closed poll' do
  expect(page).to have_content('This poll is closed.')
  expect(page).not_to have_css('.search-box')
  expect(page).not_to have_css('.custom-text')
  expect(page).not_to have_button('Choose Winner')
  expect(page).not_to have_css('.edit-button')
  expect(page).not_to have_css('.close-button')
end
