class AddInvitationTextToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :invitation_text, :string, limit: 400
  end
end
