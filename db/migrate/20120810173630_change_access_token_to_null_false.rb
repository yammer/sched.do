class ChangeAccessTokenToNullFalse < ActiveRecord::Migration
  def up
    change_column_null :users, :encrypted_access_token, :string, false
  end

  def down
    change_column_null :users, :encrypted_access_token, :string, true
  end
end
