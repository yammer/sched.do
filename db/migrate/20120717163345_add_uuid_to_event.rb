class AddUuidToEvent < ActiveRecord::Migration
  def change
    add_column :events, :uuid, :string
  end
end
