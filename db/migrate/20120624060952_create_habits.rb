class CreateHabits < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.string :statement
      t.date :goal_date
      t.references :user

      t.timestamps
    end
    add_index :habits, [:user_id, :created_at]
  end
end
