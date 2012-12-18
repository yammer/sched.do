class AddVoteIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :vote_id, :integer
    add_index :invitations, :vote_id
  end
end
