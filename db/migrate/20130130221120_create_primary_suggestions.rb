class CreatePrimarySuggestions < ActiveRecord::Migration
  def change
    create_table :primary_suggestions do |t|
      t.timestamps
      t.integer :event_id, null: false
      t.string :description, null: false
    end
  end
end
