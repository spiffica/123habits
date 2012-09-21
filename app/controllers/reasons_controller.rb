
class ReasonsController < ApplicationController


  def create
    @habit = current_user.habits.find(params[:habit_id])
    @reason = @habit.reasons.build(params[:reason])
    respond_to do |format|
      if @reason.save
          # following works, but need to figure js to update or trigger
          # affirmations#create.js.erb and format highlight to notify
          # user that it needs to be converted to affirmation
        @habit.affirmations.create(params[:reason])
        format.html { redirect_to @habit, notice: "New reason created." }
        format.js   
      else
        format.html { redirect_to @habit, notice: "New reason not created" }
        format.js   { render 'reload'}
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
    @habit = current_user.habits.find(params[:habit_id])
    @reason = @habit.reasons.find(params[:id])
    @reason.destroy
    respond_to do |format|
      format.html { redirect_to @habit, notice: "Reason successfully destroyed" }
      format.js   
    end   
  end
end
