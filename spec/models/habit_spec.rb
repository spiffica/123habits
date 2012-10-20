require 'spec_helper'

describe Habit do
  describe "#day_streak" do
    before do
      @habit = FactoryGirl.create(:habit, start_date: Date.today)
    end
    context "with two failed days followed by 3 success days" do
      it "should return 3" do
        @habit.stub_chain(:trackers,:pending,:count).and_return(18)
        @habit.day_streak.should == 3
      end    
    end
  end

  describe "#percent_success" do
    before do
      @habit = FactoryGirl.create(:habit, start_date: Date.today)
    end
    it "returns success/unsuccessful" do
      @habit.stub_chain(:trackers, :success_days, :count).and_return(3)
      @habit.stub_chain(:trackers, :marked, :count).and_return(10)
      @habit.percent_success.should == 30
    end
    it "returns 0 when no successful days" do
      @habit.stub_chain(:trackers, :success_days, :count).and_return(20)
      @habit.stub_chain(:trackers, :marked, :count).and_return(0)
      @habit.percent_success.should == 0
      
    end
  end
  describe "date calculations" do
    before do    
      @habit = FactoryGirl.create(:habit)
      @habit.status = "started"
      @habit.save
    end
    describe "#end_date" do
      it "is the last trackers day value" do

        @habit.trackers.last.day.should == @habit.end_date
        @habit.trackers.last.day.should == Date.today + 20
      end
    end
    describe "#days_left" do
      it "returns number of days til end of habit" do

        @habit.stub_chain(:trackers, :last, :day).and_return(Time.zone.today + 12.days)
        @habit.days_left.should == 12
      end
    end
    describe "#days_ago_started" do
      it "returns 0 on first day" do
        @habit.days_ago_started.should == 0
      end
      it "returns 20 on the last day" do
        Timecop.travel( 20.days)
        @habit.days_ago_started.should == 20
      end
    end
  end


  describe "#check_status" do
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
