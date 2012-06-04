module EventCreation
  def create_event(name, suggestion)
    visit root_path
    fill_in 'event_name', with: name
    find_field_by_data_role('suggestion').set(suggestion)
    click_button 'Create event'
  end
end

RSpec.configure do |c|
  c.include EventCreation
end
