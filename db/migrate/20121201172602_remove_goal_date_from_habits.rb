class RemoveGoalDateFromHabits < ActiveRecord::Migration
  def up
    remove_column :habits, :goal_date
  end

  def down
    add_column :habits, :goal_date, :date
  end
end
