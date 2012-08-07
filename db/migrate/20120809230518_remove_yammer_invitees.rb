class RemoveYammerInvitees < ActiveRecord::Migration
  def up
    drop_table :yammer_invitees
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
