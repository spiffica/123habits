module HabitsHelper

  def progress_message_for(habit)
    num_days = habit.day_streak
    case num_days
    when 1
     msg = "Congratulations. This is the first day of your new habit."
    when 15
      msg = "Way to go. You have hit the half way mark!!"
    else
      msg = "You are on your way"
    end
    content_tag(:small, msg)
  end

  def habit_synopsis(habit)
    if habit.status == "started"
      link_to(habit_trackers_path(habit), title: "view progress", 
        id: "tracking_link") do
          content_tag(:p, "Habit underway for #{pluralize(habit.day_streak, 'day')}",
            class: 'day_streak') +
          progress_message_for(habit) 
      end
    else
      if habit.status == "pending"
        yield if block_given?
      end
      if habit.status == "completed"
        content_tag(:p, "Congratulations")
      end
    end

  end



  def habit_status(habit)
    content_tag(:h3) do
       ("Status: " + content_tag(:span, habit.status,
        class: "status #{habit.status}")).html_safe
    end
  end

end
