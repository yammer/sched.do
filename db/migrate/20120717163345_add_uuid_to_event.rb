class AddUuidToEvent < ActiveRecord::Migration
  def change
    add_column :events, :uuid, :string
    event_ids = select_values('SELECT id FROM events')

    event_ids.each do |event_id|
      update "UPDATE events SET uuid = '#{SecureRandom.hex(4)}' WHERE id = #{event_id}"
    end

    change_column :events, :uuid, :string, null: false, :limit => 8
  end
end
