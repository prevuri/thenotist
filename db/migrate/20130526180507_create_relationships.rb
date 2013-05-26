class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :buddy_id
      t.boolean :blocked

      t.timestamps
    end

    add_index :relationships, :user_id
    add_index :relationships, :buddy_id
    add_index :relationships, [:user_id, :buddy_id], unique: true
  end
end
