step 'I should see a suggestion of :suggestion' do |suggestion|
  within '.suggestions' do
    page.should have_content suggestion
  end
end

step 'I view the :event_name event' do |event_name|
  event = Event.find_by_name!(event_name)
  visit event_path(event)
end

step 'I should not see an edit link' do
  page.should have_no_css('a', text: 'Edit')
end
