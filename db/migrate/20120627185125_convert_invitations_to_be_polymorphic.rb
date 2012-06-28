class ConvertInvitationsToBePolymorphic < ActiveRecord::Migration
  def up
    remove_column :invitations, :name
    add_column :invitations, :invitee_type, :string
    # For now this is just staging and development data, so say
    # 'bye bye' to invitations without user ids
    delete("DELETE FROM invitations WHERE user_id IS NULL")
    update("UPDATE invitations SET invitee_type = 'User'")
    change_column_null :invitations, :invitee_type, false
    rename_column :invitations, :user_id, :invitee_id
    change_column_null :invitations, :invitee_id, false
  end

  def down
    change_column_null :invitations, :invitee_id, true
    update("UPDATE invitations SET invitee_id = NULL WHERE invitee_type = 'YammerInvitee'")
    delete("DELETE FROM invitations WHERE invitee_type NOT IN ('User', 'YammerInvitee')")
    remove_column :invitations, :invitee_type
    rename_column :invitations, :invitee_id, :user_id
    add_column :invitations, :name, :string
    select_all("SELECT id, name FROM users").each do |row|
      update("UPDATE invitations SET name = #{connection.quote(row['name'])} WHERE user_id = #{row['id']}")
    end
    change_column_null :invitations, :name, false
  end
end
