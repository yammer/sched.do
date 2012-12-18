class AddRemindedAtToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :reminded_at, :datetime
    add_index :invitations, :reminded_at
  end
end
