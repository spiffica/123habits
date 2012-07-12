class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :content
      t.references :habit

      t.timestamps
    end
    add_index :steps, :habit_id
  end
end
