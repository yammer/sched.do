class AddUserIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :user_id, :integer, null: false
    add_index :votes, [:suggestion_id, :user_id], unique: true
  end
end
