class CreateContributors < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.references :user
      t.integer :shared_note_id

      t.timestamps
    end
    add_index :contributors, [:shared_note_id, :user_id], :name => "index_contributors_on_shared_note_id_and_user_id", :unique => true
    add_index :contributors, [:shared_note_id], :name => "index_contributors_on_shared_note_id"
    add_index :contributors, [:user_id], :name => "index_contributors_on_user_id"
  end
end
