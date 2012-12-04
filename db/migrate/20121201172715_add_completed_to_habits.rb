class AddCompletedToHabits < ActiveRecord::Migration
  def change
    add_column :habits, :completed_date, :date
  end
end
