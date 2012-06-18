class CreateGuestVotes < ActiveRecord::Migration
  def change
    create_table :guest_votes do |t|
      t.string :name, null: false
      t.string :email, null: false
    end
  end
end
