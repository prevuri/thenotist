class DropTableUserFbData < ActiveRecord::Migration
  def up
  	drop_table :user_fb_data
  end

  def down
  end
end
