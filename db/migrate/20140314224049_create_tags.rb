class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :user_id
      t.integer :note_id

      t.timestamps
    end

    add_index :tags, :name
    add_index :tags, :user_id
    add_index :tags, :note_id
    add_index :tags, [:user_id, :note_id]
    add_index :tags, [:name, :user_id, :note_id]
  end
end
