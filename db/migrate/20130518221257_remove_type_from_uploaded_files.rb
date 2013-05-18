class RemoveTypeFromUploadedFiles < ActiveRecord::Migration
  def up
    remove_column :uploaded_files, :type
  end

  def down
  end
end
