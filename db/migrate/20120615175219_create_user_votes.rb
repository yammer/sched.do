class CreateUserVotes < ActiveRecord::Migration
  def up
    add_column :votes, :votable_id, :integer, null: false
    add_column :votes, :votable_type, :string, null: false

    create_table :user_votes do |t|
      t.integer :user_id, null: false
    end
    add_index :user_votes, :user_id

    select_all("SELECT id, user_id FROM votes").each do |row|
      votable_id = insert("INSERT INTO user_votes(user_id) VALUES (#{row['user_id']})")
      update("UPDATE votes SET votable_type = 'UserVote', votable_id = #{votable_id} WHERE id = #{row['id']}")
    end

    remove_column :votes, :user_id
  end

  def down
    add_column :votes, :user_id, :integer

    select_all("SELECT id, user_id FROM user_votes").each do |row|
      update("UPDATE votes SET user_id = #{row['user_id']} WHERE votable_id = #{row['id']}")
    end

    drop_table :user_votes

    remove_column :votes, :votable_type
    remove_column :votes, :votable_id
  end
end
