class TrackerManager
  attr_reader :habit, :trackers
	def initialize(habit)
		@habit = habit
    @trackers = habit.trackers
	end

	def create_initial_trackers
		# date = Time.zone.now.to_date
  #   #remove @habit.completed_date
  #   if @habit.completed_date && @habit.completed_date == date
  #     date += 1.day
  #   end
    date = set_start_date
    (Habit::LENGTH).times do |x|
      state = x == 0? "current" : "pending"
      trackers.create(day:date, outcome: state)
      date += 1.day
    end
  end

  def delete_trackers
  	trackers.delete_all
  end

  def add_penalty_trackers 
  	date = trackers.last.day
    habit.penalty.times do |n|
      date += 1.day
      trackers.create(day:date)
    end
  end

  private
    def set_start_date
      date = Time.zone.now.to_date
      if habit.completed_date == date
        date += 1.day
      end
      date
    end

end