step 'I should see :text in the notice flash' do |text|
  expect(find('#flash-notice')).to have_content text
end

step 'I should see :text in the error flash' do |text|
  expect(find('#flash-error')).to have_content text
end
