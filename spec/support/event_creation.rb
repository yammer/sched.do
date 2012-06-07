module EventCreation
  def create_event(name, suggestions)
    suggestions = Array.wrap(suggestions)
    visit root_path
    fields = find_fields_by_data_role('suggestion')
    if fields.size < suggestions.size
      raise "Too many suggestions: #{suggestions.size} suggestions for only #{fields.size} fields!"
    end
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
