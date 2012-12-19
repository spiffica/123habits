 
class HabitsController < ApplicationController
 
  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(params[:habit])
    respond_to do |format|
      if @habit.save
        format.html { redirect_to @habit }
        format.mobile { redirect_to root_path }
        
      else
        format.html { render :new }
        format.mobile { render :new }
      end
    end
  end

  def show
    @habit = current_user.habits.find(params[:id])
    @reason = @habit.reasons.build
    @reasons = @habit.reasons.order("created_at ASC")
    @step = @habit.steps.build
    @steps = @habit.steps.order("created_at ASC")
    @affirmation = @habit.affirmations.build
    @affirmations = @habit.affirmations.order("created_at ASC")
    @trackers = @habit.trackers.order("id")
    @t_options = @trackers.markable.any? && !params[:month] ?
                { month: @trackers.first_markable_month,
                  year: @trackers.first_markable_year } : {}
  end

  def edit
    @habit = current_user.habits.find(params[:id])
  end

  def update
    @habit = current_user.habits.find(params[:id])
    respond_to do |format|
      if @habit.update_attributes(params[:habit])
        format.html do
          flash[:success] = "Habit successfully updated."
          redirect_to @habit
        end
        format.mobile do
          flash[:success] = "Habit updated."
          redirect_to @habit
        end
        format.js { @habits = current_user.habits.order_status_start }
      else
        format.html do
          flash[:error] = "Please try again"
          render :edit
        end
        format.mobile { render :edit }
        format.js { render 'edit' }
      end
    end
  end


  def destroy
    @habit = current_user.habits.find(params[:id])
    @habit.destroy
    respond_to do |format|
      format.html do
        flash[:success] = "Habit successfully destroyed"
        redirect_to current_user
      end
      format.mobile { redirect_to current_user }
      format.js
    end
  end



  # def continue
  #   @habit = current_user.habits.find(params[:id])
  #   @habit.continue_habit
  #   redirect_to @habit
  # end

end
