class RenameVoteVotableToUser < ActiveRecord::Migration
  def change
    rename_column :votes, :votable_id, :user_id
    rename_column :votes, :votable_type, :user_type
  end
end
