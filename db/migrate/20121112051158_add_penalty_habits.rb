class AddPenaltyHabits < ActiveRecord::Migration
  def up
  	add_column :habits, :penalty, :integer, :default=>7
  end

  def down
  	remove_column :habits, :penalty
  end
end
