class RemoveNonNullFromSuggestionIdOnVoteTable < ActiveRecord::Migration
  def up
    change_column(:votes, :suggestion_id, :integer, null: true)
  end

  def down
  end
end
