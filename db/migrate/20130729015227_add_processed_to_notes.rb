class AddProcessedToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :processed, :boolean, :default => false
    add_column :notes, :processing_started_at, :timestamp
    add_column :notes, :aborted, :boolean, :default => false
    add_index :notes, :processed, :name => 'index_notes_on_processed'
  end
end
