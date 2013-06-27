step 'I choose :option as the winning option' do |option|
  find("a[@title='#{option}']", text: 'Choose Winner').click
  click_button('Send message and close poll')
end

step 'I should not be able to choose a winning option' do
  expect(page).not_to have_content('Choose Winner')
end

step 'I should see the open graph discussion feed' do
  expect(page).to have_content('Discuss this poll')
  expect(page).to have_css('#yammer-feed')
end

step 'I should see a closed poll' do
  expect(page).to have_content('This poll is closed.')
  expect(page).to have_content('Winner!')
  expect(page).not_to have_css('.search-box')
  expect(page).not_to have_css('.custom-text')
  expect(page).not_to have_button('Choose Winner')
  expect(page).not_to have_css('.edit-button')
  expect(page).not_to have_css('.close-button')
  expect(page).not_to have_css('.remind-all')
  expect(page).not_to have_css('.remind')
  expect(page).not_to have_css('.winner-button')
end

step 'I cannot vote' do
  expect(page).to have_css('.grid.disabled')
  within '.votable' do
    vote_button = find('input[@type="submit"]')
    expect(vote_button['disabled']).to eq 'disabled'
  end
end
