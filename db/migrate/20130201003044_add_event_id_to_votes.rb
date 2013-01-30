class AddEventIdToVotes < ActiveRecord::Migration
  def change
    add_column(:votes, :event_id, :integer)
  end
end
