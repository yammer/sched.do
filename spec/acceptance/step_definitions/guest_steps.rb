step 'I should be prompted to login or enter my name and email' do
  page.should have_css('a#sign-in')
  page.should have_css('form#new_guest')
end

step 'I enter my name and email' do
  fill_in_guest_info
end
