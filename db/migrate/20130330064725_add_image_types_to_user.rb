class AddImageTypesToUser < ActiveRecord::Migration
  def change
    add_column :users, :sq_image, :string
    add_column :users, :s_image, :string
    add_column :users, :l_image, :string
  end
end
