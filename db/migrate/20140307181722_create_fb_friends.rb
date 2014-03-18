class CreateFbFriends < ActiveRecord::Migration
  def change
    create_table :fb_friends do |t|
      t.string :uid
      t.string :name
      t.string :profile_image
      t.references :user

      t.timestamps
    end
    add_index :fb_friends, :user_id
  end
end
