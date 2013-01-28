class AddDefaultValueToYammerNetworkNameColumnInUsersTable < ActiveRecord::Migration
  def up
    change_column :users, :yammer_network_name, :string, default: '', null: false
  end

  def down
    change_column :users, :yammer_network_name, :string, null: true
  end
end
