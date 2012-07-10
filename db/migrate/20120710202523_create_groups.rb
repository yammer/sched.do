class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :yammer_group_id

      t.timestamps
    end
  end
end
