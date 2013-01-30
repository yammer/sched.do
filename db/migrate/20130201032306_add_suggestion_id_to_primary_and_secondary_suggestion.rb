class AddSuggestionIdToPrimaryAndSecondarySuggestion < ActiveRecord::Migration
  def change
    add_column(:primary_suggestions, :suggestion_id, :integer)
    add_column(:secondary_suggestions, :suggestion_id, :integer)
  end
end
