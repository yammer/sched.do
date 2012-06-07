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

step 'I should see an event named :event_name with a suggestion of :suggestion' do |event_name, suggestion|
  page.should have_css('.event-name', text: event_name)

  within '.suggestions' do
    page.should have_content suggestion
  end
end

step 'I should see an event with the following suggestions in order:' do |table|
  suggestions = table.raw.map(&:first)
  within '.suggestions' do
    all('.description').each_with_index do |element, i|
      element.should have_content suggestions[i]
    end
  end
end

step 'I should see multiple suggestions' do
  all('input[data-role=suggestion]').size.should be > 1
end

step 'I should see a link to that event' do
  page.should have_content event_url(Event.order('id').last)
end
