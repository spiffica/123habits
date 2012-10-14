require 'spec_helper'

describe Tracker do
	let(:habit) { FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5) }
	describe "#add_initial_trackers" do
    it "adds 21 tracker days to habit" do
      Tracker.add_initial_trackers habit
      habit.should have(21).trackers
      habit.trackers.first.id.should_not be_nil
    end
  end
  describe "#add_penalty_days(x)" do
    it "add x days to the habits' day count" do
      habit.status = "started"
      habit.save
      track1 = habit.trackers.first
      track1.add_penalty_days(10)

      habit.trackers.count.should eq(31)
    end
    it "gracefully handles negative numbers" do
      habit.status = "started"
      habit.save
      track1 = habit.trackers.first
      track1.add_penalty_days(-10)
      habit.trackers.count.should eq(21)
    end
  end
  describe "#check_success" do
		before do
  		habit.status = "started"
  		habit.save
  		@trackers = habit.trackers
  	end
  	it "invokes #add_penalty_days when :success => false"  do
  		tracker1 = @trackers[0]
  		tracker1.success = false
  		tracker1.save
      tracker2 = @trackers[1]
      tracker2.success = false
      tracker2.save
  		
  		@trackers.count.should eq(23) 
  	end
  	it "does nothing when :success => true" do
  		tracker10 = @trackers[9]
  		tracker10.success = true
  		tracker10.save

  		@trackers.count.should eq 21
  	end
  end
  describe "#days_to_add" do
    before do
      habit.status = "started"
      habit.save
      @tracker = habit.trackers.first
    end
    it "adds proper number of days" do
      #@tracker.days_to_add.should == 0
      @tracker.success = false
      @tracker.save
      @tracker.days_to_add.should == 1
    end
  end
  
end
