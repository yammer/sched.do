class AddOpenToEvents < ActiveRecord::Migration
  def up
    change_table :events do |t|
      t.boolean :open, default: true
    end
    Event.update_all ["open = ?", true]
  end

  def down
    remove_column :events, :open
  end
end
