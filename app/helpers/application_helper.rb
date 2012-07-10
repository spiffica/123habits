module ApplicationHelper

  def full_title page_title
    base_title = 'Habit Buster'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def current_habits
    @habits ||= current_user.habits.all
  end
end
