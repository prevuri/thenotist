class AddContributingNoteIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :contributing_note_id, :integer
  end
end
