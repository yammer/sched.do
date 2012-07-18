step 'I should see a suggestion of :suggestion' do |suggestion|
  within '.grid' do
    page.should have_content suggestion
  end
end

step 'I visit an the event show page' do
  visit event_url(Event.order(:id).last)
end

step 'I should not be able to access it by id' do
  create(:event)
  lambda {
    visit "/events/#{Event.order('id').last.id}"
  }.should raise_error(ActionController::RoutingError)
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

  within '.grid' do
    page.should have_content suggestion
  end
end

step 'I should see an event with the following suggestions in order:' do |table|
  suggestions = table.raw
  within '.grid' do
    all('.description').each_with_index do |element, i|
      element.should have_content suggestions[i][0]
      if suggestions[i][1]
        element.should have_content suggestions[i][1]
      end
    end
  end
end

step 'I should see multiple suggestions' do
  all("input[data-role='primary-suggestion']").size.should be > 1
end

step 'I should see a link to that event' do
  url = event_url(Event.order('id').last)
  page.find("#event-url").value.should == url
end
