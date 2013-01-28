class AddYammerNetworkNameColumnToUsersTable < ActiveRecord::Migration
  def up
    add_column :users, :yammer_network_name, :string

    execute(
      <<-SQL
        UPDATE users
        SET yammer_network_name = TRIM(BOTH ' ' FROM SUBSTRING(extra FROM '\"network_name\":\"(.+?)\"'))
        WHERE substring(extra FROM '\"network_name\":\"(.+?)\"') IS NOT NULL
      SQL
    )

    execute(
      <<-SQL
        UPDATE users
        SET yammer_network_name = TRIM(both ' ' FROM SUBSTRING(extra FROM '\nnetwork_name:(.+?)\n'))
        WHERE SUBSTRING(extra FROM '\nnetwork_name:(.+?)\n') IS NOT NULL
      SQL
    )
  end

  def down
    remove_column :users, :yammer_network_name
  end
end
