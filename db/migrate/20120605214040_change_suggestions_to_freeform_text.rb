class ChangeSuggestionsToFreeformText < ActiveRecord::Migration
  def up
    remove_column :suggestions, :time
    add_column :suggestions, :description, :string, null: false, default: ''

    exec_update(%q<UPDATE suggestions SET description = '[none]' WHERE description IS NULL OR description = ''>)
  end

  def down
    remove_column :suggestions, :description
    add_column :suggestions, :time, :datetime, null: false, default: Time.at(0)
  end
end
