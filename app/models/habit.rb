class Habit < ActiveRecord::Base

  TYPE = [['Start a healthy habit', 'start'],['Kick an ugly habit','kick']] #["grow", "break"]
  STATUS  = ["started", "completed", "pending"]

  belongs_to :user
  has_many :reasons, dependent: :destroy
  has_many :steps, dependent: :destroy

  attr_accessible :goal_date, :statement, :habit_type, :status, :start_date

  validate :future_date
  validates :statement, presence: true, length: { minimum: 10}
  validates :user_id, presence: true
  validates :habit_type, presence: true

  #below not working, not sure why
  #default_scope :order, 'habits.created_at DESC'

  private

    def future_date
      if goal_date <= Date.today
        errors.add(:goal_date, "can't be in the past")
      end
    end


end
