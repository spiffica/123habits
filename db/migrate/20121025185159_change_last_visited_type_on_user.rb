class ChangeLastVisitedTypeOnUser < ActiveRecord::Migration
  def up
  	rename_column :users, :last_visited, :old_last_visited
  	add_column :users, :last_visited, :datetime
  	remove_column :users, :old_last_visited
  end

  def down
  	rename_column :users, :last_visited, :old_last_visited
  	add_column :users, :last_visited, :time
  	remove_column :users, :old_last_visited
  end
end
