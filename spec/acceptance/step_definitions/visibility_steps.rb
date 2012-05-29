step 'I should see :text' do |text|
  page.should have_content text
end
