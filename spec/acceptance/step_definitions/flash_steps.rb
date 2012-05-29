step  'I should see :text in the error flash' do |text|
  find('#flash_error').should have_content text
end
