class DropTableContributors < ActiveRecord::Migration
  def up
  	drop_table :contributors
  end

  def down
  end
end
