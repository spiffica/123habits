require 'spec_helper'

describe TrackerManager do
  let(:habit) { FactoryGirl.create(:habit, statement: "indecisive", 
              user_id: 5) }
	it "requires habit object in init"
	describe "#create_initial_trackers" do
		it "creates 21 new trackers for this habit" do
			TrackerManager.new(habit).create_initial_trackers
			expect(Tracker.count).to eql 21
		end
    it "starts first day on today" do
			TrackerManager.new(habit).create_initial_trackers
      Tracker.first.day.should == Date.today
    end
    it "starts first day on day after completed date if exists" do
      habit.stub(:completed_date).and_return(Date.today)
			TrackerManager.new(habit).create_initial_trackers
      Tracker.first.day.should == Date.today + 1.day
    end

  end
  describe "#add_penalty_trackers" do
    it "add 7 days to the habits' day count" do
      habit.update_attribute(:status, "started")
      TrackerManager.new(habit).add_penalty_trackers

      habit.trackers.count.should eq(28)
    end
  end
end