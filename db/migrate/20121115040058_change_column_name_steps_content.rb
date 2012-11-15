class ChangeColumnNameStepsContent < ActiveRecord::Migration
  def up
  	rename_column :steps, :content, :message
  end

  def down
  	rename_column :steps, :message, :content
  end
end
