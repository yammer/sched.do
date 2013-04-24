class AddTimeBasedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_based, :boolean, default: false, null: false

    set_time_based_on_existing_rows
  end

  private

  def set_time_based_on_existing_rows
    rows = select_all('SELECT event_id, description FROM primary_suggestions')

    convert_to_hash(rows).each do |id, descriptions|
      time_based = descriptions.all? { |text| time_based?(text) }

      if time_based
        execute("UPDATE events SET time_based = TRUE WHERE id = #{id}")
      end
    end
  end

  def time_based?(text)
    begin
      DateTime.parse(text)
      true
    rescue ArgumentError
      false
    end
  end

  def convert_to_hash(rows)
    rows.inject({}) do |result, row|
      result[row['event_id']] ||= []
      result[row['event_id']] << row['description']
      result
    end
  end
end
