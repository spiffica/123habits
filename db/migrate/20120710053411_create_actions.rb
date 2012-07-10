class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :content
      t.references :habit

      t.timestamps
    end
    add_index :actions, :habit_id
  end
end
