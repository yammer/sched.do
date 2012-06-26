module EventCreation
  def create_event(name = 'Potluck', suggestions = %w(meatloaf))
    visit root_path

    suggestion_manager = SuggestionManager.new(suggestions, page)

    fill_in 'event_name', with: name
    suggestion_manager.fill_in_fields
    click_button 'Create event'
  end

  class SuggestionManager
    def initialize(suggestions, page)
      hashify_suggestions(suggestions)
      @page = page
      @fields = []
    end

    def hashify_suggestions(suggestions)
      @suggestions = {}
      Array.wrap(suggestions).each do |suggestion|
        if suggestion.kind_of?(Array)
          @suggestions[suggestion[0]] ||= []
          if suggestion[1].present?
            @suggestions[suggestion[0]] << suggestion[1]
          end
        else
          @suggestions[suggestion] = []
        end
      end
    end

    def find_suggestion_fields
      @fields = @page.all('.nested-fields.primary').map { |section| NestedFieldsSection.new(section) }
    end

    def fill_in_fields
      add_fields_for_suggestions
      @suggestions.keys.each_with_index do |key, index|
        if @suggestions[key].kind_of?(Array)
          @fields[index].fill_in_primary_suggestion(key)
          @fields[index].fill_in_secondary_suggestions(@suggestions[key])
        else
          @fields[index].fill_in_primary_suggestion(key)
        end
        @fields[index].wait_for_primary_fields_to_update
      end
    end

    def add_fields_for_suggestions
      find_suggestion_fields
      add_primary_suggestion_fields
      add_secondary_suggestion_fields
    end

    def add_primary_suggestion_fields
      (@suggestions.size - @fields.size).times do
        @page.click_link 'Add Another Day'
      end
      find_suggestion_fields
    end

    def add_secondary_suggestion_fields
      @suggestions.keys.each_with_index do |key, index|
        (@suggestions[key].size - @fields[index].size).times do
          @fields[index].add_secondary_field
        end
      end
      find_suggestion_fields
    end
  end

  private

  class NestedFieldsSection
    def initialize(section)
      @section = section
    end

    def size
      secondary_fields.size
    end

    def primary_field
      @section.find("[data-role='primary-suggestion']")
    end

    def primary_fields
      @section.all("[data-role='primary-suggestion']", visible: false)
    end

    def secondary_fields
      @section.all("[data-role='secondary-suggestion']")
    end

    def fill_in_primary_suggestion(suggestion)
      primary_field.set(suggestion)
    end

    def wait_for_primary_fields_to_update
      primary_fields.each do |field|
        Capybara.wait_until(10) do
          field.value == primary_field.value
        end
      end
    end

    def fill_in_secondary_suggestions(suggestions)
      secondary_fields.each_with_index do |field, index|
        field.set(suggestions[index])
      end
    end

    def add_secondary_field
      @section.find('.add_fields').click
    end
  end
end

RSpec.configure do |c|
  c.include EventCreation
end
