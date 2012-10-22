class Habit < ActiveRecord::Base

  TYPE = %w(kick start)  #[['Start a healthy habit', 'start'],['Kick an ugly habit','kick']] #["grow", "break"]
  STATUS  = %w(started pending completed) #["started", "pending", "completed"]
  LENGTH = 21

  belongs_to :user
  has_many :reasons, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :affirmations, dependent: :destroy
  has_many :trackers, dependent: :destroy

  attr_accessible :goal_date, :statement, :habit_type, :status, :start_date, 
                  :reward

  before_save :status_check

  #validate :future_date
  validates :statement, presence: true, length: { minimum: 6}
  validates :user_id, presence: true
  validates :habit_type, presence: true
  validates :status, inclusion: { in: STATUS }

  scope :order_status_start, order("status DESC, start_date DESC")

  STATUS.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  TYPE.each do |type|
    define_method "#{type}?" do
      self.habit_type == type
    end
  end

  class << self
    STATUS.each do |status|
      define_method "#{status}" do
        where(:status => status)
      end
    end
    TYPE.each do |type|
      define_method "#{type}" do
        where(:habit_type => type)
      end
    end
  end

  def day_streak
    (Habit::LENGTH - self.trackers.unmarked.count)
  end

  def days_ago_started
    (Time.zone.today - self.start_date).to_i
  end

  def end_date
    self.trackers.last.day unless self.pending?
  end

  def days_left
    (self.trackers.last.day - Time.zone.today).to_i 
  end

  def percent_success
    begin
      self.trackers.pass.count * 100/ self.trackers.marked.count
    rescue
      0
    end
  end

  def up_to_date?
    self.trackers.overdue.any? ? false : true
  end
  


  private

    def future_date
      if goal_date <= Time.zone.today
        errors.add(:goal_date, "can't be in the past")
      end
    end

    def status_check
      if self.status_changed? 
        case self.status 
          when "started"
          self.start_date = Time.zone.today
          Tracker.create_initial_trackers(self)
          when "pending"
          self.start_date = nil
          Tracker.delete_trackers(self)
        end
      end
    end

    



end
# == Schema Information
#
# Table name: habits
#
#  id         :integer         not null, primary key
#  statement  :string(255)
#  goal_date  :date
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  habit_type :string(255)     default("kick")
#  status     :string(255)     default("pending")
#  start_date :date
#  reward     :string(255)
#

