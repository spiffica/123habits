class TrackersController < ApplicationController
  before_filter :set_habit
  include ActionView::Helpers::TextHelper

  def index
  	@trackers = @habit.trackers.order("id")
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
            penalty = pluralize(@habit.penalty, 'day')
		  			flash[:notice] = "Your habit has been extended by 
            #{penalty}."
		  		end
  				redirect_to @habit
  			end
        format.mobile { redirect_to habit_trackers_path(@habit) }
  			format.js
      else
        format.html do
          render "Ah!!!"
        end
  		end
  	end
  end

  private
  
    def set_habit
      @habit = current_user.habits.find(params[:habit_id])
    end
end
