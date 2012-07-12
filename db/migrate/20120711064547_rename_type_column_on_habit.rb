class RenameTypeColumnOnHabit < ActiveRecord::Migration
  def up
    rename_column :habits, :type, :habit_type
  end

  def down
  end
end
