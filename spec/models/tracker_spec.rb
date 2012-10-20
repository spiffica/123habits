require 'spec_helper'

describe Tracker do
  let(:habit) { FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5) }
  describe "#create_initial_trackers" do
    it "adds 21 tracker days to habit" do
      Tracker.create_initial_trackers habit
      habit.should have(21).trackers
      habit.trackers.first.id.should_not be_nil
    end
  end
  describe "#add_penalty_trackers(x)" do
    it "add x days to the habits' day count" do
      habit.status = "started"
      habit.save
      track1 = habit.trackers.first
      track1.add_penalty_trackers(10)

      habit.trackers.count.should eq(31)
    end
    it "gracefully handles negative numbers" do
      habit.status = "started"
      habit.save
      track1 = habit.trackers.first
      track1.add_penalty_trackers(-10)
      habit.trackers.count.should eq(21)
    end
  end
  describe "#check_success" do
    before do
      habit.status = "started"
      habit.save
      @trackers = habit.trackers
    end
    it "invokes #add_penalty_trackers when :success => false"  do
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
  describe "#trackers_to_add" do
    before do
      habit.status = "started"
      habit.save
      @tracker = habit.trackers.first
    end
    it "adds proper number of days" do
      #@tracker.trackers_to_add.should == 0
      @tracker.success = false
      @tracker.save
      @tracker.trackers_to_add.should == 1
    end
  end

  describe "#first_pending?" do
    it "returns true for first pending tracker" do
      habit.status = "started"
      habit.save
      first_tracker = habit.trackers.first
      first_tracker.first_pending?.should == true
    end
  end
  describe "#first_pending" do
    it "returns only first tracker not yet filled" do
      habit.status = "started"
      habit.save
      habit.trackers.count.should == 21
      Timecop.travel(Date.today + 5.days)
      @trackers = habit.trackers
      first_returned = @trackers.pending.first
      @trackers.last.first_pending.should === first_returned
    end
  end
  
end
# == Schema Information
#
# Table name: trackers
#
#  id         :integer         not null, primary key
#  day        :date
#  success    :boolean
#  notes      :string(255)
#  habit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

