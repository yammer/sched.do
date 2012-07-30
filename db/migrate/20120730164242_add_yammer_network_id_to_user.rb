class AddYammerNetworkIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :yammer_network_id, :integer

    User.all.each do |user|
      user.update_attribute(:yammer_network_id, user.extra['raw_info']['network_id'])
    end

    change_column :users, :yammer_network_id, :integer, null: false
  end
end
