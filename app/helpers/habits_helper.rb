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

  def when_habit_started(habit)
    num = habit.days_ago_started
    msg = ''
    if num == 0
      msg = "Today"
    else
      msg = "#{pluralize(num, 'day')} ago"
    end
    msg
  end

  def habit_synopsis(habit)
    if habit.started?
      link_to(habit_trackers_path(habit), title: "view progress", 
        id: "tracking_link") do
        render 'stats',:habit => habit
      end
    else
      if habit.pending?
        yield if block_given?
      end
      if habit.completed?
        content_tag(:p, "Congratulations")
      end
    end

  end

  def up_to_date_state(habit)
    habit.up_to_date? ? "Up to date" : "Not up to date"
  end



  def habit_status(habit)
    content_tag(:h3) do
       ("Status: " + content_tag(:span, habit.status,
        class: "status #{habit.status}")).html_safe
    end
  end

end
