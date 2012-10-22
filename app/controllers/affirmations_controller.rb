class AffirmationsController < ApplicationController

  before_filter :set_habit

  def index
  end

  def edit
    @affirmation = @habit.affirmations.find(params[:id])
  end

  def update
    @affirmation = @habit.affirmations.find(params[:id])
    respond_to do |format|
      if @affirmation.update_attributes(params[:affirmation])
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

  def create
    @affirmation = @habit.affirmations.build(params[:affirmation])
    respond_to do |format|
      if @affirmation.save
        format.html { redirect_to @habit, notice: "New affirmation created." }
        format.js   
      else
        format.html { redirect_to @habit, notice: "New affirmation not created" }
        format.js   { render 'reload'}
      end
    end
  end

  def destroy
    @affirmation = @habit.affirmations.find(params[:id])
    @affirmation.destroy
    respond_to do |format|
      format.html { redirect_to @habit, notice: "Affirmation successfully destroyed" }
      format.js   
    end 
  end
    private
  
    def set_habit
      @habit = current_user.habits.find(params[:habit_id])
    end

end
