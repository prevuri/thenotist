class AddThumbUrlToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :thumb_url, :string
  end
end
