class AddDefaultToSuggestionTime < ActiveRecord::Migration
  def up
    change_column_default :suggestions, :time, Time.at(0)
  end

  def down
    change_column_default :suggestions, :time, nil
  end
end
