class RemoveContributingNotesFromUser < ActiveRecord::Migration
  def up
  	remove_column :users, :contributing_note_id
  end

  def down
  end
end
