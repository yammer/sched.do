class AddSecondaryColumnToSuggestions < ActiveRecord::Migration
  def change
    rename_column :suggestions, :description, :primary
    add_column :suggestions, :secondary, :string, null: false, default: ''
  end
end
