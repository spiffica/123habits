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

  describe "#reset_start_date" do
    before do
      @habit = FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5)
    end
    context "when status changed to 'started'" do
      it "sets start date to today" do
        @habit.status = "started"
        @habit.save
        @habit.start_date.should == Time.zone.today
        # expect { @habit.save }.to change(@habit, :start_date).to(Time.zone.today)
      end
    end
    context "when status changed to 'pending'" do
      it "sets start date to nil" do
        @habit.status = "pending"
        @habit.save
        @habit.start_date.should == nil
      end
    end
    context "when Habit saved" do
      it "sets start_date to nil" do
        @habit.start_date.should == nil
      end
      it "sets status to 'pending'" do
        @habit.status.should == 'pending'
      end
    end
  end


end
