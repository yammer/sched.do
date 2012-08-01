class AddEmailToYammerInvitee < ActiveRecord::Migration
  def change
    add_column :yammer_invitees, :email, :string
  end
end
