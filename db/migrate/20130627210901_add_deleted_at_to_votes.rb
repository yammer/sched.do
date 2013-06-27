class AddDeletedAtToVotes < ActiveRecord::Migration
  def up
    add_column :votes, :deleted_at, :datetime
  end

  def down
    remove_column :votes, :deleted_at
  end
end
