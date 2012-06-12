module EventCreation
  def create_event(name = 'Potluck', suggestions = %w(meatloaf))
    suggestions = Array.wrap(suggestions)
    visit root_path
    fields = find_fields_by_data_role('suggestion')
    (suggestions.size - fields.size).times do
      click_link 'Add Another Suggestion'
    end
    fields = find_fields_by_data_role('suggestion')
    fill_in 'event_name', with: name
    suggestions.each_with_index do |suggestion, i|
      fields[i].set(suggestion)
    end
    click_button 'Create event'
  end
end

RSpec.configure do |c|
  c.include EventCreation
end
