class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.datetime :time, null: false
      t.integer :event_id, null: false

      t.timestamps
    end
  end
end
