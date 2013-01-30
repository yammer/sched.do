class CreateSecondarySuggestions < ActiveRecord::Migration
  def change
    create_table :secondary_suggestions do |t|
      t.timestamps
      t.integer :primary_suggestion_id, null: false
      t.string :description, null: false
    end
  end
end
