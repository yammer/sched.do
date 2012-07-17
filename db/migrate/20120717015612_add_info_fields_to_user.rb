class AddInfoFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :text
    add_column :users, :image, :text
    add_column :users, :yammer_profile_url, :text

    execute <<-SQL
      UPDATE users
      SET yammer_profile_url = '';
    SQL

    change_column :users, :yammer_profile_url, :text, null: false
  end
end
