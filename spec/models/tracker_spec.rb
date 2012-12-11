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
    it "starts first day on today" do
      Tracker.create_initial_trackers habit
      Tracker.first.day.should == Date.today
    end
    it "starts first day on day after completed date if exists" do
      habit.stub(:completed_date).and_return(Date.today)
      Tracker.create_initial_trackers habit
      Tracker.first.day.should == Date.today + 1.day
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
      habit.class.should == Habit
      @trackers[0].update_attributes(:outcome => "pass")
      @trackers[1].update_attributes(:outcome => "pass")
      @trackers[2].update_attributes(:outcome => "pass")
      @trackers[3].update_attributes(:outcome => "pass")
      @trackers[4].update_attributes(:outcome => "pass")
      @trackers[5].update_attributes(:outcome => "pass")
      @trackers[6].update_attributes(:outcome => "pass")
      @trackers[7].update_attributes(:outcome => "fail")
      # @trackers[3].update_attribute(:outcome, "fail")
      
      @trackers.count.should eq(28)
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
      #TODO not sure why this test not working
      habit.trackers.stub_chain(:unmarked,:count).and_return(4)
      habit.trackers.unmarked.count.should == 4
      # habit.trackers.count.should eq(21) 
      habit.trackers.first.trackers_to_add.should == 18
    end
  end

  describe "#first_markable?" do
    it "returns true for first markable tracker" do
      habit.class.should == Habit
      habit.update_attribute(:status, "started")
      first_tracker = habit.trackers.first
      first_tracker.first_markable?.should == true
    end
  end
  describe "#marked" do
    it "returns true for all marked trackers in habit" do
      habit.update_attribute(:status, "started")
      @trackers = habit.trackers      
      @first = @trackers.first
      @first.stub(:outcome).and_return("pass")
      @first.marked?.should == true
      @first.stub(:outcome).and_return("fail")
      @first.marked?.should == true
    end
  end
  describe "#first_markable" do
    before do
      habit.update_attribute(:status, "started")
      # habit.trackers.count.should == 21
      Timecop.travel(Date.today + 5.days)
      @trackers = habit.trackers
    end
    it "returns only first tracker not yet filled" do
      first_returned = @trackers.markable.first
      @trackers.first_markable.should === first_returned
    end
    it "returns 3rd tracker after first two filled in" do
      @trackers[0].update_attribute(:outcome, "pass")
      @trackers[1].update_attribute(:outcome, "pass")
      @trackers.update_unmarked_trackers "Madrid"
      @trackers.first_markable.should == @trackers[2]
      @trackers[2].first_markable?.should == true
    end
  end
  
  #Testing the new states of Tracker 
  #scopes
  describe "scope :unmarked" do
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
  describe "scope :marked" do
    it "concats fail and pass" do
      habit.update_attribute(:status,"started")
      Tracker.count.should == 21
      Tracker.marked.count.should == 0
      Tracker.update_all(outcome: "pass")
      Tracker.last.update_attribute(:outcome, "fail")
      Tracker.update_unmarked_trackers "Madrid"

      Tracker.marked.count.should == 21
      Tracker.unmarked.count.should == 7
      Tracker.marked.count.should == 21
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

      habit.trackers.update_unmarked_trackers "Madrid"
      
      habit.trackers.current.count.should == 1
      habit.trackers.markable.count.should == 5
      habit.trackers.count.should == 21
      habit.trackers.overdue.count.should == 4
      habit.trackers.pending.count.should == 16
    end

  end
  describe "::update_to_current" do
    it "shows count" do
      100.times do |n|
        Tracker.stub(:trackers)
        Tracker.create :habit_id => (20 + n), :day => Time.zone.today 
      end
      50.times { Tracker.create(:habit_id => 8888, :day => Date.yesterday) }
      Tracker.update_to_current "Madrid"
      Tracker.current.count.should == 100
    end
    it "works?" do 
      habit.update_attribute(:status, "started")
      Tracker.current.count.should == 1
      Tracker.pending.count.should == 20

    end      
  end

  describe "scope :day_is_today" do
    it "returns all trackers with day =to today" do
      100.times { Tracker.create :habit_id => 1, :day => Time.zone.today }
      50.times { Tracker.create(:habit_id => 1, :day => Date.yesterday) }
      # Timecop.travel 5.days
      # Tracker.last.day.should == Date.tomorrow
      # Time.zone.today.should == 'oct 5'
      Tracker.count.should == 150
      Tracker.day_is_today.count.should == 100
    end
  end
  describe "::update_to_overdue" do
      #currently already done ahead by mark_overdue_trackers
    it "updates trackers' :outcome to 'overdue' if in past" do
      100.times { Tracker.create :habit_id => 8888, :day => Time.zone.today }
      50.times { Tracker.create(:habit_id => 8888, :day => Date.yesterday) }
      Tracker.update_to_overdue
      Tracker.overdue.count.should == 50
      
    end
  end
  describe "scope :day_is_past" do
    it "returns all trackers with :day in past" do
      100.times { Tracker.create :habit_id => 8888, :day => Time.zone.today }
      50.times { Tracker.create(:habit_id => 8888, :day => Date.yesterday) }
      Tracker.day_is_past.count.should == 50      
    end
  end
  describe "calendar" do
    # before do
    #   @first = 
  
    describe "::first_markable_month" do
      it "responds to method" do
        Tracker.should respond_to :first_markable_month
      end
      it "returns month of first markable tracker" do
        Tracker.stub_chain(:first_markable,:day,:month).and_return(5)
        Tracker.first_markable_month.should eq(5)
      end
    end
    describe "::first_markable_year" do
      it "responds to method" do
        Tracker.should respond_to :first_markable_year
      end
      it "returns year of first markable tracker" do
        Tracker.stub_chain(:first_markable,:day,:year).and_return(2010)
        Tracker.first_markable_year.should eq(2010)
      end
      
    end
  end
end
# == Schema Information
#
# Table name: trackers
#
#  id         :integer         not null, primary key
#  day        :date
#  notes      :text
#  habit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  outcome    :string(255)     default("pending")
#

