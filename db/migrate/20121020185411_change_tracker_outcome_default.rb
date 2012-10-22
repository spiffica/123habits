class ChangeTrackerOutcomeDefault < ActiveRecord::Migration
  def change
  	change_column_default :trackers, :outcome, "pending"
  end

end
