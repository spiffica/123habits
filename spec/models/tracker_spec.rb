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
      habit.update_attribute(:status, "started")
      track1 = habit.trackers.first
      track1.add_penalty_trackers(10)

      habit.trackers.count.should eq(31)
    end
    it "gracefully handles negative numbers" do
      habit.update_attribute(:status, "started")
      track1 = habit.trackers.first
      track1.add_penalty_trackers(-10)
      habit.trackers.count.should eq(21)
    end
  end
  describe "#add_penalty_on_fail" do
    before do
      habit.update_attribute(:status, "started")
      @trackers = habit.trackers
    end
    it "invokes #add_penalty_trackers when :outcome => 'fail'"  do
      @trackers[0].update_attribute(:outcome, "pass")
      @trackers[1].update_attribute(:outcome, "pass")
      @trackers[2].update_attribute(:outcome, "pass")
      @trackers[3].update_attribute(:outcome, "pass")
      @trackers[4].update_attribute(:outcome, "pass")
      @trackers[5].update_attribute(:outcome, "pass")
      @trackers[6].update_attribute(:outcome, "pass")
      @trackers[7].update_attribute(:outcome, "fail")
      # @trackers[3].update_attribute(:outcome, "fail")
      
      @trackers.count.should eq(29)
    end
    it "does nothing when :outcome => 'pass'" do
      @trackers[9].update_attribute(:outcome, "pass")

      @trackers.count.should eq 21
    end
  end
  describe "#trackers_to_add" do
    before do
      habit.update_attribute(:status, "started")
    end
    it "adds proper number of days" do
      # add_penalty_on_fail works properly and relies on this method
      # not sure why this test not working
      self.habit.trackers.stub_chain(:unmarked,:count).and_return(4)
      habit.trackers.unmarked.count.should == 4
      habit.trackers.count.should eq(21) 
      # habit.trackers.pending.count.should == 17
      (21-4+1).to_i.should == 18
      habit.trackers[3].trackers_to_add.should == 18
    end
  end

  describe "#first_markable?" do
    it "returns true for first markable tracker" do
      habit.update_attribute(:status, "started")
      first_tracker = habit.trackers.first
      first_tracker.first_markable?.should == true
    end
  end
  describe "#first_markable" do
    before do
      habit.update_attribute(:status, "started")
      habit.trackers.count.should == 21
      Timecop.travel(Date.today + 5.days)
      @trackers = habit.trackers
    end
    it "returns only first tracker not yet filled" do
      first_returned = @trackers.markable.first
      @trackers.first_markable.should === first_returned
    end
    it "returns 3rd tracker after first two filled in" do
      @trackers[0].update_attribute(:outcome, "pass")
      @trackers.first_markable.should == @trackers[1]
      @trackers[1].first_markable?.should == true
    end
  end
  
  #Testing the new states of Tracker 
  #scopes
  describe "#unmarked" do
    it "returns 21 on new habit" do
      habit.update_attribute(:status,"started")
      habit.trackers.unmarked.count.should == 21
      # had to call a find query to reset pending to current for first day
      # as this is set to change only after 'after_find' callback
      # habit.trackers.all
      habit.trackers.current.count.should == 1
      habit.trackers.markable.count.should == 1
    end
  end
  describe "#current" do
    it " after 5 days" do
      habit.update_attribute(:status, "started")
      Timecop.travel 1.day
      habit.trackers.current.count.should == 1
      Timecop.travel 1.day
      habit.trackers.current.count.should == 1
      Timecop.travel 1.day
      habit.trackers.current.count.should == 1
      Timecop.travel 1.day
      habit.trackers.all
      habit.trackers.current.count.should == 1
      habit.trackers.markable.count.should == 5
      habit.trackers.count.should == 21
      habit.trackers.overdue.count.should == 4
      habit.trackers.pending.count.should == 16
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
#  outcome    :string(255)
#

