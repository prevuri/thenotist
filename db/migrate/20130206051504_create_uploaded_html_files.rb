class CreateUploadedHtmlFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_html_files do |t|
      t.integer :note_id
      t.integer :page_number
      t.string :public_path
      t.string :thumb_url

      t.timestamps
    end
  end
end
