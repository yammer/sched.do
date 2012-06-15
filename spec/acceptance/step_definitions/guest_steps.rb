step 'I should be prompted to login or enter my name and email' do
  page.should have_css('a#sign-in')
  page.should have_css('form#new_guest')
end

step 'I enter my name and email' do
  within '#new_guest' do
    fill_in 'name', with: 'Joe Schmoe'
    fill_in 'email', with: 'joe@example.com'
    click_button 'Begin Voting'
  end
end
