class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.references :user
      t.integer :shared_note_id

      t.timestamps
    end
    add_index :contributors, :user_id
  end
end
