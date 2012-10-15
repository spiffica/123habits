class Tracker < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :day, :notes, :success, :habit_id
  has_calendar :start_time => :day

  before_save :check_success

  scope :pending, where(:success => nil)
  scope :current, where("day <= ?",Time.zone.today)

  HABIT_LENGTH = 21

  def get_habit
    self.habit
  end

  def first_pending
     get_habit.trackers.pending.current.first
  end

  def first_pending?
    trackers = get_habit.trackers
    first = trackers.pending.current.first
    self == first
  end

  def self.add_initial_trackers(habit)
  	date = Time.zone.now.to_date
    HABIT_LENGTH.times do
      habit.trackers.create(day:date)
      # Tracker.create(day:date,habit_id:self.id)
      date += 1.day
    end
  end

  def add_penalty_days(number)
    # habit = self.habit
    date = get_habit.trackers.last.day
    number.times do |n|
      date += 1.day
      habit.trackers.create(day:date)
    end
  end

  def days_to_add
    # habitt = self.habit
    (HABIT_LENGTH - get_habit.trackers.pending.count + 1).to_i
  end    

  def check_success
    if self.success_changed? && self.success == false
      add_penalty_days(days_to_add)
      # extend_trackers
    end
  end

  def self.delete_trackers(habit)
  	habit.trackers.delete_all
  end
end
