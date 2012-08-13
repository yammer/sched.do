class ConvertYammerUserIdOnUsersToInteger < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE users ALTER COLUMN yammer_user_id TYPE integer
      USING CAST(yammer_user_id as INTEGER);'
  end

  def down
    execute 'ALTER TABLE users ALTER COLUMN yammer_user_id TYPE text
      USING CAST(yammer_user_id as TEXT);'
  end
end
