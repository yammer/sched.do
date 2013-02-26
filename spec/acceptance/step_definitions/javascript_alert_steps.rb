step 'I should see :text in the confirmation dialog' do |text|
  expect(page.driver.confirm_messages).to include(text)
end

step 'I should not see a confirmation dialog' do
  expect(page.driver.confirm_messages).to be_empty
end
