class RemoveImageFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :sq_image
    remove_column :users, :s_image
    remove_column :users, :l_image
    remove_column :users, :image
  end

  def down
    add_column :users, :image, :string
    add_column :users, :l_image, :string
    add_column :users, :s_image, :string
    add_column :users, :sq_image, :string
  end
end
