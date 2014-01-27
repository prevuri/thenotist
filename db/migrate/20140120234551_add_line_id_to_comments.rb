class AddLineIdToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :line_id, :string
  end
end
