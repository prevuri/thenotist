class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :uploaded_file_id
      t.text :text
      t.decimal :ycoord

      t.timestamps
    end
  end
end
