class AddExtraToUser < ActiveRecord::Migration
  def change
    add_column :users, :extra, :text
  end
end
