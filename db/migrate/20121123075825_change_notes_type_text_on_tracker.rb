class ChangeNotesTypeTextOnTracker < ActiveRecord::Migration
  def up
  	change_column :trackers, :notes, :text
  end

  def down
  	change_column :trackers, :notes, :string
  end
end 
