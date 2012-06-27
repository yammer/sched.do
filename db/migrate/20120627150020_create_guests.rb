class CreateGuests < ActiveRecord::Migration
  def up
    create_table :guests do |t|
      t.string :name
      t.string :email, null: false
      t.timestamps
    end

    add_column :guest_votes, :guest_id, :integer

    select_all("SELECT id, email, name FROM guest_votes").each do |row|
      guest_id = insert("INSERT INTO guests(name, email, created_at, updated_at) \
                         VALUES (#{connection.quote(row['name'])}, #{connection.quote(row['email'])}, #{connection.quote(Time.now)}, #{connection.quote(Time.now)})")
      update("UPDATE guest_votes SET guest_id = #{guest_id} WHERE id = #{row['id']}")
    end

    change_column_null :guest_votes, :guest_id, :integer, false

    remove_column :guest_votes, :name
    remove_column :guest_votes, :email
  end

  def down
    add_column :guest_votes, :name, :string
    add_column :guest_votes, :email, :string

    select_all("SELECT id, name, email FROM guests").each do |row|
      update("UPDATE guest_votes SET name = #{connection.quote(row['name'])}, email = #{connection.quote(row['email'])} WHERE guest_id = #{row['id']}")
    end

    change_column :guest_votes, :name, :string
    change_column_null :guest_votes, :email, :string, false

    remove_column :guest_votes, :guest_id

    drop_table :guests
  end
end
