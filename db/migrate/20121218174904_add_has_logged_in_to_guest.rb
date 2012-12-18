class AddHasLoggedInToGuest < ActiveRecord::Migration
  def change
    add_column :guests, :has_logged_in, :boolean, :default => false, null: false
  end
end
