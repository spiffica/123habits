class TrackersController < ApplicationController
  def index
  	@habit = current_user.habits.find(params[:habit_id])
  	@trackers = @habit.trackers.all
  end

  def show
    @habit = current_user.habits.find(params[:habit_id])
    @tracker = @habit.trackers.find(params[:id])
  end

  def edit
  	@habit = current_user.habits.find(params[:habit_id])
  	@tracker = @habit.trackers.find(params[:id])
  end

  def update
  	@habit = current_user.habits.find(params[:habit_id])
  	@tracker = @habit.trackers.find(params[:id])
    respond_to do |format|
  	  if @tracker.update_attributes(params[:tracker])
  			format.html do
		  		if @tracker.outcome == "fail"
		  			flash[:notice] = "Sorry, your 21 days will start again tomorrow."
		  		end
  				redirect_to habit_trackers_path
  			end
  			format.js
      else
        format.html do
          render "Ah shit!!!"
        end
  		end
  	end
  end
end
