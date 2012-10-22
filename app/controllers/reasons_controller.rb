
class ReasonsController < ApplicationController

  before_filter :set_habit
  def create
    @reason = @habit.reasons.build(params[:reason])
    respond_to do |format|
      if @reason.save
        format.html { redirect_to @habit, notice: "New reason created." }
        format.js   
      else
        format.html { redirect_to @habit, notice: "New reason not created" }
        format.js   { render 'reload'}
      end
    end
  end

  def edit
    @reason = @habit.reasons.find(params[:id])
  end

  def update
    @reason = @habit.reasons.find(params[:id])
    respond_to do |format|
      if @reason.update_attributes(params[:reason])
        format.html do 
          flash[:success] = "Reason successfully updated."
          redirect_to  habit_path(@habit)
        end
        format.js
      else
        format.html { render :edit }
        format.js  { render 'edit'}
      end
    end
    
  end

  def destroy
    @reason = @habit.reasons.find(params[:id])
    @reason.destroy
    respond_to do |format|
      format.html { redirect_to @habit, notice: "Reason successfully destroyed" }
      format.js   
    end   
  end

  private
    def set_habit
      @habit = current_user.habits.find(params[:habit_id])
    end
end
