class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name, null: false
      t.integer :event_id, null: false
      t.integer :user_id, null: true

      t.timestamps
    end
  end
end
