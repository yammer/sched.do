step 'show me the page' do
  save_and_open_page
end

step 'I see the javascript errors' do
  ap page.driver.error_messages
end
