class AddOutcomeToTracker < ActiveRecord::Migration
  def change
    add_column :trackers, :outcome, :string
  end
end
