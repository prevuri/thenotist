class AddParentCommentIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :parent_comment_id, :integer
  end
end
