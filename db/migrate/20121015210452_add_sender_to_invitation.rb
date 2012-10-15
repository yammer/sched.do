class AddSenderToInvitation < ActiveRecord::Migration
  def up
    add_column :invitations, :sender_id, :integer
    add_column :invitations, :sender_type, :string

    select_all('SELECT id, event_id FROM invitations;').each do |row|
      event = select_one("SELECT user_id FROM events where id=#{row['event_id']};")
      update("UPDATE invitations SET sender_id = #{event['user_id']} where id=#{row['id']};")
      update("UPDATE invitations SET sender_type = 'User' where id=#{row['id']};")
    end

    change_column_null :invitations, :sender_id, true
    change_column_null :invitations, :sender_type, true

    add_index :invitations, :sender_id
    add_index :invitations, :sender_type
  end

  def down
    remove_index :invitations, :sender_id
    remove_index :invitations, :sender_type
    remove_column :invitations, :sender_id
    remove_column :invitations, :sender_type
  end
end
