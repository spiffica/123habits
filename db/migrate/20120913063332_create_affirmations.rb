class CreateAffirmations < ActiveRecord::Migration
  def change
    create_table :affirmations do |t|
      t.string :message

      t.timestamps
    end
  end
end
