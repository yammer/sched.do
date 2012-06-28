class CreateYammerInvitees < ActiveRecord::Migration
  def change
    create_table :yammer_invitees do |t|
      t.string :yammer_user_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
