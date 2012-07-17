module HabitsHelper

  def days_in_habit(habit)
    num_days = habit.day_streak
    case num_days
    when 1
     msg = "Congratulations. This is the first day of your new habit."
    when 15
      msg = "Way to go. You have hit the half way mark!!"
    else
      msg = "You are on your way"
    end
 end
end
