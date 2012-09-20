class AddHabitIdToAffirmations < ActiveRecord::Migration
  def change
  	add_column :affirmations, :habit_id, :integer
  end
end
