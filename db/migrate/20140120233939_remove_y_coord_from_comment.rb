class RemoveYCoordFromComment < ActiveRecord::Migration
  def up
  	remove_column :comments, :ycoord
  end

  def down
  	add_column :comments, :line_id, :string
  end
end
