class SetDefaultTimeZoneForUser < ActiveRecord::Migration
  def up
        change_column_default :users, :time_zone, 'Pacific Time (US & Canada)'
  end

  def down
  end
end
