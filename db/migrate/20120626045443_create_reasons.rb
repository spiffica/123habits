class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.string :message
      t.integer :importance
      t.references :habit

      t.timestamps
    end
    add_index :reasons, :habit_id
  end
end
