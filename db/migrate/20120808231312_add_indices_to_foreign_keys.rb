class AddIndicesToForeignKeys < ActiveRecord::Migration
  def change
    add_index :events, :user_id
    add_index :events, :uuid
    add_index :groups, :yammer_group_id
    add_index :guests, :email
    add_index :guest_votes, :guest_id
    add_index :invitations, :event_id
    add_index :invitations, :invitee_id
    add_index :suggestions, :event_id
    add_index :users, :encrypted_access_token
    add_index :users, :yammer_network_id
    add_index :users, :yammer_user_id
    add_index :votes, :votable_id
    add_index :yammer_invitees, :yammer_user_id
  end
end
