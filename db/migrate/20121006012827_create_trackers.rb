class CreateTrackers < ActiveRecord::Migration
  def change
    create_table :trackers do |t|
      t.date :day
      t.boolean :success
      t.string :notes
      t.belongs_to :habit

      t.timestamps
    end
    add_index :trackers, :habit_id
  end
end
