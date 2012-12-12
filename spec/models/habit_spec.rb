require 'spec_helper'

describe Habit do
  describe "#day_streak" do
    before do
      @habit = FactoryGirl.create(:habit)
      @fail = mock(Tracker, :outcome => "fail")
      @pass = mock(Tracker, :outcome => "pass")
      # @habit.update_attribute(:status, "started")      
    end
    context "with two failed days followed by 3 success days" do
      it "should return 3" do
        @habit.stub_chain(:trackers,:marked).and_return(
          [@fail,@fail,@pass,@pass,@pass])
          
        @habit.day_streak.should == 3
      end    
    end
    context "on first day, with nothing marked" do
      it "returns 0" do
        @habit.stub_chain(:trackers,:marked).and_return([])

        @habit.day_streak.should == 0
      end
    end
    context "with one day marked 'pass'" do
      it "returns 1" do
        @habit.stub_chain(:trackers,:marked).and_return([@pass])
        @habit.day_streak.should == 1
      end
    end
    context "with one day marked 'fail'" do
      it "returns 0" do
        @habit.stub_chain(:trackers,:marked).and_return([@fail])
        @habit.day_streak.should == 0
      end
    end
    context "with two days marked 'pass'" do
      it "returns 2" do
        @habit.stub_chain(:trackers,:marked).and_return([@pass,@pass])

        @habit.day_streak.should == 2
      end
    end
  end

  describe "#percent_success" do
    before do
      @habit = FactoryGirl.create(:habit, start_date: Date.today)
    end
    it "returns success/unsuccessful" do
      @habit.stub_chain(:trackers, :pass, :count).and_return(3)
      @habit.stub_chain(:trackers, :marked, :count).and_return(10)
      @habit.percent_success.should == 30
    end
    it "returns 0 when no successful days" do
      @habit.stub_chain(:trackers, :pass, :count).and_return(20)
      @habit.stub_chain(:trackers, :marked, :count).and_return(0)
      @habit.percent_success.should == 0
      
    end
  end
  describe "date calculations" do
    before do    
      @habit = FactoryGirl.create(:habit)
    end
    describe "#end_date" do
      it "is the last trackers day value" do
        @habit.stub(:pending?).and_return(false)
        @habit.stub_chain(:trackers,:last,:day).and_return(Date.today)

        @habit.end_date.should == Date.today
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
        @habit.stub(:start_date).and_return(Date.today)
        @habit.days_ago_started.should == 0
      end
      it "returns 20 on the last day" do
        @habit.stub(:start_date).and_return(Date.today - 20.days)

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
        # probably better to let it touch callback on its own
        # @habit.stub(:status_changed?).and_return(true)
        # @habit.stub(:status).and_return("started")

      end
      it "sets start date to today" do
        @habit.start_date.should == Time.zone.today
        # @habit.send(:status_check)
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
    context "when status changed to 'monitoring'" do
      before do
        @habit.update_attribute(:status, 'monitoring')
      end
      it "adds 21 trackers" do
        Tracker.count.should == 21
      end
    end
    context "when Habit saved" do
      it "sets start_date to nil" do
        @habit.start_date.should == nil
      end
      it "sets status to 'pending'" do
        @habit.pending?.should == true
      end
      it "has no trackers" do
        @habit.trackers.count.should eq(0)
      end
    end
    describe "#up_to_date" do
      before do
        @habit.update_attribute :status, "started"
      end
      it "returns true when first started" do
        @habit.stub_chain(:trackers, :overdue,:any?).and_return(false)
        @habit.up_to_date?.should == true
      end
      it "returns false with one unmarked yesterday" do
        @habit.stub_chain(:trackers, :overdue, :any?).and_return(true)
        @habit.up_to_date?.should == false
      end
    end

    describe "#pass_count" do
      it { should respond_to :pass_count }
      it "returns proper number of passed days" do
        @habit.stub_chain(:trackers, :pass, :count).and_return(5)
        @habit.pass_count.should == 5
      end
    end
  end





end
# == Schema Information
#
# Table name: habits
#
#  id             :integer         not null, primary key
#  statement      :string(255)
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  habit_type     :string(255)     default("kick")
#  status         :string(255)     default("pending")
#  start_date     :date
#  reward         :string(255)
#  penalty        :integer         default(7)
#  completed_date :date
#

