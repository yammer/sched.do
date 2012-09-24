step 'I should see :text in the notice flash' do |text|
  find('#flash-notice').should have_content text
end

step 'I should see :text in the error flash' do |text|
  find('#flash-error').should have_content text
end
