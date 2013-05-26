class RenameUserId < ActiveRecord::Migration
  def up
  	change_table :relationships do |t|
      t.rename :user_id, :follower_id
    end
  end

  def down
  end
end
