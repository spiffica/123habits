class AddLastVisitedToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_visited, :time
  end
end
