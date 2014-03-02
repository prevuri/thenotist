class CreateFlagReports < ActiveRecord::Migration
  def change
    create_table :flag_reports do |t|
      t.integer :note_id
      t.boolean :report_resolved
      t.boolean :doc_removed
      t.string :description
      t.string :report_type

      t.timestamps
    end
  end
end
