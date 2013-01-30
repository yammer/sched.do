class AddIndexsToPrimaryAndSecondarySuggestions < ActiveRecord::Migration
  def change
    add_index(:primary_suggestions, :event_id)
    add_index(:primary_suggestions, :description)
    add_index(:secondary_suggestions, :primary_suggestion_id)
    add_index(:secondary_suggestions, :description)
  end
end
