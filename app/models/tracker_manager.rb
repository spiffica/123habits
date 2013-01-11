class TrackerManager

	def initialize(habit)
		@habit = habit
	end

	def create_initial_trackers
		date = Time.zone.now.to_date
    if @habit.completed_date && @habit.completed_date == date
      date += 1.day
    end
    (Habit::LENGTH).times do |x|
      state = x == 0? "current" : "pending"
      @habit.trackers.create(day:date, outcome: state)
      date += 1.day
    end
  end

  def delete_trackers
  	@habit.trackers.delete_all
  end

  def add_penalty_trackers 
  	date = @habit.trackers.last.day
    @habit.penalty.times do |n|
      date += 1.day
      @habit.trackers.create(day:date)
    end
  end

end