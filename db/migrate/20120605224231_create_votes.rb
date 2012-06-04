class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :suggestion_id, null: false

      t.timestamps
    end

    add_index :votes, :suggestion_id
  end
end
