class AddFlaggedToNote < ActiveRecord::Migration
  def change
    add_column :notes, :flagged, :boolean
  end
end
