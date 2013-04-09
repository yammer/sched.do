class AddWinningSuggestionOnEvents < ActiveRecord::Migration
  def up
    change_table :events do |t|
      t.belongs_to :winning_suggestion, polymorphic: true
    end
  end

  def down
    change_table :events do |t|
      t.remove_belongs_to :winning_suggestion, polymorphic: true
    end
  end
end
