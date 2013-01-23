step 'I share the sched.do application with my Yammer network' do
  mock_out_yammer_api({name: 'Laila', id: 12345, return_type: 'user' })
  click_button 'Share'
end

step 'I share the sched.do app and get an error from the Yammer API' do
  mock_failed_yam_request
  click_button 'Share'
end
