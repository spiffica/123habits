require 'spec_helper'

describe Habit do
  describe "#day_streak" do
    before do
      @habit = FactoryGirl.create(:habit, start_date: Date.today)
    end
    it "should return '1' for first day of habit" do
      @habit.day_streak.should == 1
    end    
  end

  describe "#end_date" do
    it "is the last trackers day value" do
      habit = FactoryGirl.create(:habit)
      habit.status = "started"
      habit.save

      habit.trackers.last.day.should == habit.end_date
      habit.trackers.last.day.should == Date.today + 20
    end
  end

  describe "#new_end_date" do
    it "is 21 day"
    
  end

  describe "#reset_start_date" do
    before do
      @habit = FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5)
    end
    context "when status changed to 'started'" do
      before do
        @habit.status = "started"
        @habit.save
      end
      it "sets start date to today" do
        @habit.start_date.should == Time.zone.today
        # expect { @habit.save }.to change(@habit, :start_date).to(Time.zone.today)
      end
      it "adds 21 trackers" do
        @habit.trackers.count.should eq(21)
      end

    end
    context "when status changed to 'pending'" do
      before do
        @habit.status = "started"
        @habit.save
        @habit.status = "pending"
        @habit.save
      end
      it "sets start date to nil" do
        @habit.start_date.should == nil
      end
      it "deletes all trackers" do
        @habit.trackers.count.should eq(0)
      end
    end
    context "when Habit saved" do
      it "sets start_date to nil" do
        @habit.start_date.should == nil
      end
      it "sets status to 'pending'" do
        @habit.status.should == 'pending'
      end
      it "has no trackers" do
        @habit.trackers.count.should eq(0)
      end
    end
  end





end
