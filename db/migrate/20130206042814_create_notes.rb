class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.integer :course_id

      t.timestamps
    end
  end
end
