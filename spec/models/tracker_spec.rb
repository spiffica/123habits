require 'spec_helper'

describe Tracker do
	 describe "#add_initial_trackers" do
    it "adds 21 tracker days to habit" do
      @habit = FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5)
      Tracker.add_initial_trackers @habit
      @habit.should have(21).trackers
      @habit.trackers.first.id.should_not be_nil
    end
  end
  describe "#add_penalty_days" do
    it "add 7 days to the habits' day count" do
      @habit = FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5)

      @habit.status = "started"
      @habit.save
      track1 = @habit.trackers.first
      track1.success = false
      track1.save

      @habit.trackers.count.should eq(28)
    end
  end
  describe "#reset_streak"
end
