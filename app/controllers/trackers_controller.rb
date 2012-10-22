class TrackersController < ApplicationController
  before_filter :set_habit
  def index
  	@trackers = @habit.trackers.all
  end

  def show
    @tracker = @habit.trackers.find(params[:id])
  end

  def edit
  	@tracker = @habit.trackers.find(params[:id])
  end

  def update
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

  private
  
    def set_habit
      @habit = current_user.habits.find(params[:habit_id])
    end
end
