class NormalizeGuestEmails < ActiveRecord::Migration
  def change 
    ActiveRecord::Base.connection.execute('update guests set email = lower(email)')
  end
end
