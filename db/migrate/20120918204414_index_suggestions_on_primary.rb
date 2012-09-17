class IndexSuggestionsOnPrimary < ActiveRecord::Migration
  def change
    add_index :suggestions, :primary
  end
end
