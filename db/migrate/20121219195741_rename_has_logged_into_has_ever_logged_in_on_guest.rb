class RenameHasLoggedIntoHasEverLoggedInOnGuest < ActiveRecord::Migration
  def up
    rename_column :guests, :has_logged_in, :has_ever_logged_in
  end

  def down
    rename_column :guests, :has_ever_logged_in, :has_logged_in
  end
end
