class Habit < ActiveRecord::Base

  TYPE = [['Start a healthy habit', 'start'],['Kick an ugly habit','kick']] #["grow", "break"]
  STATUS  = ["started", "pending", "completed"]

  belongs_to :user
  has_many :reasons, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :affirmations, dependent: :destroy
  has_many :trackers, dependent: :destroy

  attr_accessible :goal_date, :statement, :habit_type, :status, :start_date, :reward

  before_save :reset_start_date

  #validate :future_date
  validates :statement, presence: true, length: { minimum: 6}
  validates :user_id, presence: true
  validates :habit_type, presence: true

  scope :order_status_start, order("status DESC, start_date DESC")

  def day_streak
    (Time.zone.now.to_date - self.start_date).to_i + 1
  end

  def end_date
    self.trackers.last.day unless self.status == "pending" 
  end
  


  private

    def future_date
      if goal_date <= Time.zone.today
        errors.add(:goal_date, "can't be in the past")
      end
    end

    def reset_start_date
      if self.status_changed? 
        case self.status 
          when "started"
          self.start_date = Time.zone.today
          Tracker.add_initial_trackers(self)
          when "pending"
          self.start_date = nil
          Tracker.delete_trackers(self)
        end
      end
    end

    



end
