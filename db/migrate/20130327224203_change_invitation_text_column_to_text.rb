class ChangeInvitationTextColumnToText < ActiveRecord::Migration
  def up
    change_column :invitations, :invitation_text, :text
  end

  def down
    change_column :invitations, :invitation_text, :string, limit: 400
  end
end
