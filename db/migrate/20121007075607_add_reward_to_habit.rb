class AddRewardToHabit < ActiveRecord::Migration
  def change
    add_column :habits, :reward, :string
  end
end
