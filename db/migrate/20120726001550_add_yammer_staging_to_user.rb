class AddYammerStagingToUser < ActiveRecord::Migration
  def change
    add_column :users, :yammer_staging, :boolean, :default => false
  end
end
