class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :access_token, null: false
      t.string :encrypted_access_token, null: false
      t.string :salt, null: false
      t.string :yammer_user_id, null: false

      t.timestamps
    end
  end
end
