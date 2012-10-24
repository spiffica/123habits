class RemoveSuccessTrackers < ActiveRecord::Migration
  def up
  	remove_column :trackers, :success
  end

  def down
  end
end
