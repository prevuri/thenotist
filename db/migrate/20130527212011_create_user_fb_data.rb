class CreateUserFbData < ActiveRecord::Migration
  def change
    create_table :user_fb_data do |t|
      t.integer :user_id
      t.string :uid
      t.string :profile_image
      t.string :link

      t.timestamps
    end
  end
end
