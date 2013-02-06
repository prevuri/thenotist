class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.integer :note_id
      t.integer :page_number
      t.string :type
      t.integer :height
      t.integer :width
      t.string :public_path

      t.timestamps
    end
  end
end
