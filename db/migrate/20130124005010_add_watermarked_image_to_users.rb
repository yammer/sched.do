class AddWatermarkedImageToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :watermarked_image
  end
end
