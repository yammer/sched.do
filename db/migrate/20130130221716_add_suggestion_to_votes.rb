class AddSuggestionToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :new_suggestion_id, :integer
    add_column :votes, :new_suggestion_type, :string
  end
end
