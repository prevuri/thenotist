class CreateUploadedThumbFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_thumb_files do |t|
      t.string :public_path
      t.integer :note_id
      t.integer :page_number

      t.timestamps
    end
  end
end
