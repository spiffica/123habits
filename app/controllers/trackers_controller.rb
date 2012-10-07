class TrackersController < ApplicationController
  def index
  	@habit = current_user.habits.find(params[:habit_id])
  	@trackers = @habit.trackers.all
  end

  def show
  end

  def edit
  end

  def update
  	@habit = current_user.habits.find(params[:habit_id])
  	@tracker = @habit.trackers.find(params[:id])
  	if @tracker.update_attributes(params[:tracker])
  		if @tracker.success == false
  			flash[:notice] = "Sorry, we have added another 7 days for the failed day"
  		end
  		redirect_to habit_trackers_path
  	end
  end
end
