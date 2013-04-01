class RemoveAccessTokenFromUser < ActiveRecord::Migration
  def up
    select_all("SELECT id, access_token FROM users").each do |row|
      encrypted_access_token = ActiveSupport::Base64.encode64(Encryptor.encrypt(row['access_token'], key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']))
      update("UPDATE users SET encrypted_access_token = #{connection.quote(encrypted_access_token)} WHERE id = #{row['id']}")
    end
    remove_column :users, :access_token
  end

  def down
    add_column :users, :access_token, :string
  end
end
