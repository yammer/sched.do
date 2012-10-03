class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :sender_id, null: false
      t.string :sender_type, null: false
      t.integer :receiver_id, null: false
      t.string :receiver_type, null: false

      t.timestamps
    end

    add_index :reminders, :sender_id
    add_index :reminders, :sender_type
    add_index :reminders, :receiver_id
    add_index :reminders, :receiver_type
  end
end
