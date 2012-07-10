
class ReasonsController < ApplicationController


  def create
    @habit = current_user.habits.find(params[:habit_id])
    @reason = @habit.reasons.build(params[:reason])
    respond_to do |format|
      if @reason.save
        format.html { redirect_to @habit, notice: "New reason created." }
        format.js   
      else
        format.html { redirect_to @habit, notice: "New reason not created" }
      end
    end
  end

  def edit
    @habit = current_user.habits.find(params[:habit_id])
    @reason = @habit.reasons.find(params[:id])
  end

  def update
    @habit = current_user.habits.find(params[:habit_id])
    @reason = @habit.reasons.find(params[:id])
    if @reason.update_attributes(params[:reason])
        flash[:success] = "Reason successfully updated."
        redirect_to @habit
    else
        render :edit
    end
    
  end

  def destroy
    @habit = current_user.habits.find(params[:habit_id])
    @reason = @habit.reasons.find(params[:id])
    @reasons = @habit.reasons
    @reason.destroy
    respond_to do |format|
      format.html { redirect_to @habit, notice: "Reason successfully destroyed" }
      format.js   
    end   
  end
end
