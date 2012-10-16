class Tracker < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :day, :notes, :success, :habit_id
  has_calendar :start_time => :day

  before_save :check_success

  scope :pending, where(:success => nil)
  scope :current, where("day <= ?",Time.zone.today)
  scope :success_days, where(:success => true)
  scope :marked, where(:success != nil)
  # scope :succeed, lambda { |listed| where(:success => listed)}


  def get_habit
    self.habit
  end

  def first_pending
     get_habit.trackers.pending.current.first
  end

  def first_pending?
    first = get_habit.trackers.pending.current.first
    self == first
  end

  def self.add_initial_trackers(habit)
  	date = Time.zone.now.to_date
    Habit::LENGTH.times do
      habit.trackers.create(day:date)
      # Tracker.create(day:date,habit_id:self.id)
      date += 1.day
    end
  end

  def add_penalty_trackers(number)
    # habit = self.habit
    date = get_habit.trackers.last.day
    number.times do |n|
      date += 1.day
      habit.trackers.create(day:date)
    end
  end

  def trackers_to_add
    # habitt = self.habit
    (Habit::LENGTH - get_habit.trackers.pending.count + 1).to_i
  end    

  def check_success
    if self.success_changed? && self.success == false
      add_penalty_trackers(trackers_to_add)
      # extend_trackers
    end
  end

  def self.delete_trackers(habit)
  	habit.trackers.delete_all
  end
end
