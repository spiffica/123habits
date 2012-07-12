class AddColumnsToHabit < ActiveRecord::Migration
  def change
    add_column :habits, :type, :string
    add_column :habits, :status, :string
    add_column :habits, :start_date, :date
  end
end
