module EventCreation
  def create_event(name = 'Potluck', suggestions = %w(meatloaf))
    suggestions = Array.wrap(suggestions)
    visit root_path

    fields = add_enough_fields_for_suggestions(suggestions)

    fill_in 'event_name', with: name
    fill_in_fields_with_suggestions(fields, suggestions)
    click_button 'Create event'
  end

  def find_suggestion_fields
    primary_fields = find_fields_by_data_role('primary-suggestion')
    secondary_fields = find_fields_by_data_role('secondary-suggestion')
    primary_fields.zip(secondary_fields)
  end

  def fill_in_fields_with_suggestions(fields, suggestions)
    suggestions.each_with_index do |suggestion, index|
      if suggestion.kind_of?(Array)
        fields[index][0].set(suggestion[0])
        if suggestion[1]
          fields[index][1].set(suggestion[1])
        end
      else
        fields[index][0].set(suggestion)
      end
    end
  end

  def add_enough_fields_for_suggestions(suggestions)
    fields = find_suggestion_fields
    (suggestions.size - fields.size).times do
      click_link 'Add Another Suggestion'
    end
    find_suggestion_fields
  end
end

RSpec.configure do |c|
  c.include EventCreation
end
