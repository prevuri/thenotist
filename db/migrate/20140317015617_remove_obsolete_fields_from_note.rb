class RemoveObsoleteFieldsFromNote < ActiveRecord::Migration
  def up
    remove_column :notes, :description
    remove_column :notes, :course_id
    remove_column :notes, :processing_started_at
  end

  def down
  end
end
