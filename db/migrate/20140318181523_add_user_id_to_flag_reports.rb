class AddUserIdToFlagReports < ActiveRecord::Migration
  def change
    add_column :flag_reports, :user_id, :integer
  end
end
