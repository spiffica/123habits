
class StepsController < ApplicationController

  before_filter :set_habit

  def edit
    @step = @habit.steps.find(params[:id])
  end

  def new 
    @step = @habit.steps.build
  end

  def create
    @step = @habit.steps.build(params[:step])
    respond_to do |format|
      if @step.save
        format.html { redirect_to @habit, notice: "New step created." }
        format.mobile { redirect_to habit_steps_path(@habit) }
        format.js
      else
        format.html { redirect_to @habit, notice: "something went wrong." }
        format.mobile { render :new }
        format.js   { render 'reload'}
      end
    end
  end

  def update
    @step = @habit.steps.find(params[:id])
    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html do 
          flash[:success] = "Step successfully updated."
          redirect_to @habit
        end
        format.mobile { redirect_to habit_steps_path(@habit)}
        format.js
      else
        format.html { render :edit }
        format.js   { render 'edit'}
      end
    end

  end

  def destroy
    @step = @habit.steps.find(params[:id])
    @step.destroy
    respond_to do |format|
      format.html { redirect_to @habit, notice: "Step successfully destroyed" }
      format.mobile { redirect_to habit_steps_path(@habit) }
      format.js
    end
  end

  private
  
    def set_habit
      @habit = current_user.habits.find(params[:habit_id])
    end
end
