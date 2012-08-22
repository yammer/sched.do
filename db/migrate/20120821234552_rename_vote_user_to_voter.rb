class RenameVoteUserToVoter < ActiveRecord::Migration
  def change
    rename_column :votes, :user_id, :voter_id
    rename_column :votes, :user_type, :voter_type
  end
end
