class Tracker < ActiveRecord::Base
  attr_accessible :day, :notes, :success, :habit_id, :outcome
  has_calendar :start_time => :day

  belongs_to :habit
  has_one :user, through: :habit

  STATES = %w{pending current overdue pass fail messy}

   before_save :add_penalty_on_fail
   after_update :check_completed

   # before_save 
  validates :outcome, :inclusion => { :in => STATES }
  validates :habit_id, :presence => true


  STATES.each do |state|
    define_method "#{state}?" do 
      self.outcome == state
    end
  end

  class << self
    STATES.each do |state|
      define_method "#{state}" do
        where(:outcome => state)
      end
    end
  end

  scope :marked, where(:outcome => ['fail','pass']).order("id")
  scope :unmarked, where(:outcome => ['overdue','current','pending']).order("id")
  scope :markable, where(:outcome => ['overdue','current']).order("id")
  scope :day_is_today, lambda { |tz| where("day = ?", Time.now.in_time_zone(tz).to_date) }
  scope :day_is_past, lambda { |tz| where("day < ?", Time.now.in_time_zone(tz).to_date) }
  scope :day_is_future, lambda { |tz| where("day > ?", Time.now.in_time_zone(tz).to_date) }

  def self.first_markable_month
    first_markable.day.month
  end

  def self.first_markable_year
    first_markable.day.year
  end

  def self.first_markable
    markable.first
  end


  def first_markable?
    self == self.habit.trackers.markable.first
  end

  def marked?
     self.outcome == "fail" || self.outcome == "pass"
  end


  private
    
    def self.update_to_current(user_timezone)
      self.unmarked.day_is_today(user_timezone).update_all :outcome => "current"
    end

    def self.update_to_overdue(user_timezone)
      self.unmarked.day_is_past(user_timezone).update_all :outcome => "overdue"
    end

    def self.update_to_pending(user_timezone)
      self.unmarked.day_is_future(user_timezone).update_all :outcome => "pending"
    end

    # used by rake or cron on all Trackers in app or by user
    def self.update_unmarked_trackers(user_timezone)
      self.update_to_current(user_timezone)
      self.update_to_overdue(user_timezone)
      self.update_to_pending(user_timezone)
    end

    # accessed by UserObserver
    def self.update_a_users_trackers(user)
      self.update_to_current(user.time_zone)
      self.update_to_overdue(user.time_zone)
      self.update_to_pending(user.time_zone)
    end




    def add_penalty_on_fail
      if self.outcome_changed? && self.fail?
        TrackerManager.new(self.habit).add_penalty_trackers
      end
    end

    def last_tracker
      self.habit.trackers.last
    end

    def last_tracker?
      self == last_tracker
    end

    def check_completed
      if last_tracker? && self.outcome == "pass"
        self.habit.status = "completed"
        self.habit.save
      end
    end


end
# == Schema Information
#
# Table name: trackers
#
#  id         :integer         not null, primary key
#  day        :date
#  notes      :text
#  habit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  outcome    :string(255)     default("pending")
#

