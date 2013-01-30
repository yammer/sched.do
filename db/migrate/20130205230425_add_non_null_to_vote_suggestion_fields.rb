class AddNonNullToVoteSuggestionFields < ActiveRecord::Migration
  def up
    change_column :votes, :suggestion_id, :integer, null: true
    change_column :votes, :suggestion_type, :string, null: true
  end

  def up
    change_column :votes, :suggestion_id, :integer, null: false
    change_column :votes, :suggestion_type, :string, null: false
  end
end
