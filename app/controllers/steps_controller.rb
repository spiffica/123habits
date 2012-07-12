
class StepsController < ApplicationController

    def edit
        @habit = current_user.habits.find(params[:habit_id])
        @step = @habit.steps.find(params[:id])
    end

    def create
        @habit = current_user.habits.find(params[:habit_id])
        @step = @habit.steps.build(params[:step])
        respond_to do |format|
          if @step.save
            format.html { redirect_to @habit, notice: "New step created." }
            format.js
          else
            format.html { redirect_to @habit, notice: "something went wrong." }
          end
        end
    end

    def update
      @habit = current_user.habits.find(params[:habit_id])
      @step = @habit.steps.find(params[:id])
      if @step.update_attributes(params[:step])
        flash[:success] = "Step successfully updated."
        redirect_to @habit
      else
        render :edit
      end

    end

    def destroy
      @habit = current_user.habits.find(params[:habit_id])
      @step = @habit.steps.find(params[:id])
      @step.destroy
      respond_to do |format|
        format.html { redirect_to @habit, notice: "Step successfully destroyed" }
        format.js
      end
    end

end
