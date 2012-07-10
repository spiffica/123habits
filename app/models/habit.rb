class Habit < ActiveRecord::Base
  belongs_to :user
  has_many :reasons, dependent: :destroy

  attr_accessible :goal_date, :statement

  validate :future_date
  validates :statement, presence: true, length: { minimum: 10}
  validates :user_id, presence: true

  #below not working, not sure why
  #default_scope :order, 'habits.created_at DESC'

  private

    def future_date
      if goal_date <= Date.today
        errors.add(:goal_date, "can't be in the past")
      end
    end


end
