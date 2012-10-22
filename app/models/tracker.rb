class Tracker < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :day, :notes, :success, :habit_id, :outcome
  has_calendar :start_time => :day

  STATES = %w{pending current overdue pass fail}

  before_save :add_penalty_on_fail
  after_initialize :mark_todays_tracker_current, :mark_overdue_trackers

  validates :outcome, :inclusion => { :in => STATES }
  # scope :pending, where(:success => nil)
  # scope :current, where("day <= ?",Time.zone.today)
  # scope :success_days, where(:success => true)
  # scope :failed_days, where(:success => false)
  # scope :marked, where("success IS NOT NULL")
  # scope :succeed, lambda { |listed| where(:success => listed)}

  scope :marked, where(:outcome => ['fail','pass'])
  scope :unmarked, where(:outcome => ['overdue','current','pending'])
  scope :markable, where(:outcome => ['overdue','current'])

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

  def self.first_markable
    markable.first
  end


  def first_markable?
    self == self.habit.trackers.markable.first
  end


  def self.create_initial_trackers(habit)
  	date = Time.zone.now.to_date
    (Habit::LENGTH).times do
      # state = date == Time.zone.today ? "current" : "pending"
      habit.trackers.create(day:date)
      # state = date == Time.zone.today ? "current" : "pending"
      # habit.trackers.create(day:date, outcome: state)
      date += 1.day
    end
  end

  def add_penalty_trackers(number)
    date = self.habit.trackers.last.day
    number.times do |n|
      date += 1.day
      habit.trackers.create(day:date)
    end
  end

  def trackers_to_add
    (Habit::LENGTH - self.habit.trackers.unmarked.count + 1).to_i
  end    


  def self.delete_trackers(habit)
    habit.trackers.delete_all
  end

  private
  
    def mark_todays_tracker_current
      if self.pending? && self.day == Time.zone.today
        self.update_attribute(:outcome, "current")
      end
    end

    def mark_overdue_trackers
      if (self.pending? || self.current?) && self.day < Time.zone.today
        self.update_attribute(:outcome, "overdue")
      end
    end

    def add_penalty_on_fail
      if self.outcome_changed? && self.fail?
        add_penalty_trackers(trackers_to_add)
        # extend_trackers
      end
    end
end
# == Schema Information
#
# Table name: trackers
#
#  id         :integer         not null, primary key
#  day        :date
#  success    :boolean
#  notes      :string(255)
#  habit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  outcome    :string(255)
#

