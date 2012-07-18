class RemoveMessageFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :message
  end

  def down
    add_column :events, :message, :string
  end
end
