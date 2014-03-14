class CreateIndexes < ActiveRecord::Migration
  def change
    add_index :notes, :user_id

    add_index :uploaded_html_files, :note_id
    add_index :uploaded_css_files, :note_id
    add_index :uploaded_thumb_files, :note_id

    add_index :comments, :uploaded_html_file_id
    add_index :comments, :user_id
    add_index :comments, :parent_comment_id
    add_index :comments, [:uploaded_html_file_id, :parent_comment_id]

    add_index :user_fb_data, :user_id
  end
end
