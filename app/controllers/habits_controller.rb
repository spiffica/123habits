 
class HabitsController < ApplicationController

  def new
    @habit = current_user.habits.build
  end

  def create
    @habit = current_user.habits.build(params[:habit])
    if @habit.save
      redirect_to @habit
    else
      render :new
    end
  end

  def show
    @habit = current_user.habits.find(params[:id])
    #@habits = current_user.habits.all
    @reason = @habit.reasons.build
    @reasons = @habit.reasons.all
    @step = @habit.steps.build
    @steps = @habit.steps.all
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
        format.js
      else
        format.html do
          flash[:error] = "Please try again"
          render :edit
        end
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
      format.js
    end
  end

end
