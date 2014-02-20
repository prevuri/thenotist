class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :uploaded_html_file_id
      t.integer :user_id
      t.text :text
      t.decimal :ycoord

      t.timestamps
    end
  end
end
