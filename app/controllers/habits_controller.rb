
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
  end

  def edit
    @habit = current_user.habits.find(params[:id])
  end

  def update
    @habit = current_user.habits.find(params[:id])
    if @habit.update_attributes(params[:habit])
      flash[:success] = "Habit successfully updated."
      redirect_to current_user
    else
      flash[:error] = "Please try again"
      render :edit
    end
  end

  def destroy
    @habit = current_user.habits.find(params[:id])
    @habit.destroy
    flash[:success] = "Habit successfully destroyed"
    redirect_to current_user
  end

end
