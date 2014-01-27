class CreateUploadedCsses < ActiveRecord::Migration
  def change
    create_table :uploaded_css_files do |t|
      t.string :public_path
      t.integer :note_id
      t.timestamps
    end
  end
end
