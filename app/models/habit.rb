class Habit < ActiveRecord::Base
  belongs_to :user

  attr_accessible :goal_date, :statement

  validates :statement, presence: true, length: { minimum: 10}
  validates :user_id, presence: true

  #below not working, not sure why
  #default_scope :order, 'habits.created_at DESC'
end
