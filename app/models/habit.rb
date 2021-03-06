class Habit < ActiveRecord::Base

  TYPE = %w(kick start)  
  STATUS  = %w(started pending completed monitoring)
  LENGTH = 21
 
  belongs_to :user 
  has_many :reasons, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :affirmations, dependent: :destroy
  has_many :trackers, dependent: :destroy

  attr_accessible :goal_date, :statement, :habit_type, :status, :start_date, 
                  :reward, :penalty, :completed_date

  before_save :status_check

  validates :statement, presence: true, length: { minimum: 6}
  validates :user_id, presence: true
  validates :habit_type, presence: true
  validates :status, inclusion: { in: STATUS }
  validates :penalty, presence: true, :inclusion => 1..7

  scope :order_status_start, order("status DESC, start_date DESC")
  scope :start_order, order("start_date DESC")

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
    count = 0
    self.trackers.marked.reverse.each do |t|
      break if t.outcome =="fail"
      count += 1
    end
    count
  end

  def days_ago_started
    (Time.zone.today - self.start_date).to_i
  end

  def end_date
    self.trackers.last.day unless self.pending?
  end

  def days_left
    (end_date - Time.zone.today).to_i 
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

  def pass_count
    self.trackers.pass.count
  end

  def total_days
    self.trackers.count
  end
  
  def continue_habit
    if self.status == "completed"
      TrackerManager.new(self).create_initial_trackers
      self.status = "monitoring"
      self.save
    end
  end


  private

    def tracker_manager 
      @tracker_manager ||= TrackerManager.new(self)
    end
    def create_initial_trackers
      tracker_manager.create_initial_trackers
    end
    def delete_trackers
      tracker_manager.delete_trackers
    end

    def status_check
      if self.status_changed? 
        # tm = TrackerManager.new(self)
        case self.status 
          when "started"
          self.start_date = Time.zone.today
          # tm.create_initial_trackers
          create_initial_trackers
          when "pending"
          self.start_date = nil
          delete_trackers
          when "completed"
          self.completed_date = self.trackers.last.day
          when "monitoring"
            create_initial_trackers
        end
      end
    end



 
    



end
# == Schema Information
#
# Table name: habits
#
#  id             :integer         not null, primary key
#  statement      :string(255)
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  habit_type     :string(255)     default("kick")
#  status         :string(255)     default("pending")
#  start_date     :date
#  reward         :string(255)
#  penalty        :integer         default(7)
#  completed_date :date
#

