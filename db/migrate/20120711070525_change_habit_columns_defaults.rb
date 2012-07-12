class ChangeHabitColumnsDefaults < ActiveRecord::Migration
  def up
    change_column_default :habits, :habit_type, 'kick'
    change_column_default :habits, :status, 'pending'

  end

  def down
  end
end
