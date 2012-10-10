class Tracker < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :day, :notes, :success, :habit_id
  has_calendar :start_time => :day

  before_save :add_penalty_days


  def self.add_initial_trackers(habit)
  	date = Time.zone.now.to_date
    21.times do
      habit.trackers.create(day:date)
      # Tracker.create(day:date,habit_id:self.id)
      date += 1.day
    end
  end

  def add_penalty_days
  	if self.success_changed? && self.success == false
  		habit = Habit.find(self.habit_id)
	  	date = habit.trackers.last.day
	  	7.times do |n|
	  		date += 1.day
	  		habit.trackers.create(day:date)
	  	end
	  end
  end

  def self.delete_trackers(habit)
  	habit.trackers.delete_all
  end
end
