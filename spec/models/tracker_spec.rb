require 'spec_helper'

describe Tracker do
  let(:habit) { FactoryGirl.create(:habit, statement: "indecisive", 
                user_id: 5) }
  let(:my_tracker) { FactoryGirl.create :tracker }
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


  describe "#first_markable?" do
    it "returns true for first markable tracker" do
      my_tracker.stub_chain(:habit,:trackers,:markable,:first).and_return(my_tracker)
      my_tracker.first_markable?.should eq true
    end
  end
  describe "#marked" do
    it "returns true for all marked trackers in habit" do
      my_tracker.stub(:outcome).and_return("fail")
      my_tracker.marked?.should eq true
      my_tracker.stub(:outcome).and_return("pass")
      my_tracker.marked?.should eq true
      my_tracker.stub(:outcome).and_return("pending")
      my_tracker.marked?.should eq false
      my_tracker.stub(:outcome).and_return("overdue")
      my_tracker.marked?.should eq false
      my_tracker.stub(:outcome).and_return("current")
      my_tracker.marked?.should eq false

    end
  end
  describe "#first_markable" do
    it "returns only first tracker not yet filled" do
      @first_unfilled = FactoryGirl.create :tracker, :outcome => "overdue"
      @unfilled = FactoryGirl.create :tracker, :outcome => "overdue"

      Tracker.first_markable.should == @first_unfilled

      # notice how rspec creates local factories before global
      my_tracker.id.should == 3
      @first_unfilled.id.should == 1
      @unfilled.id.should == 2
    end
    it "returns 3rd tracker after first two filled in" do
      @first_unfilled = FactoryGirl.create :tracker, :outcome => "pass"
      @unfilled = FactoryGirl.create :tracker, :outcome => "pass"
      @third = FactoryGirl.create :tracker, :outcome => "overdue"

      Tracker.first_markable.should eq @third
    end
  end
  
  #Testing the new states of Tracker 
  #scopes
  describe "scope :unmarked" do
    it "returns 21 on new habit" do
      habit.update_attribute(:status,"started")

      habit.trackers.unmarked.count.should == 21
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
      Tracker.update_unmarked_trackers "Pacific Time (US & Canada)"

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

      habit.trackers.update_unmarked_trackers "Pacific Time (US & Canada)"
      
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
        # Tracker.stub(:trackers)
        # Tracker.create :habit_id => (20 + n), :day => Time.zone.today 
        FactoryGirl.create :tracker, day: Date.today
      end
      50.times { Tracker.create(:habit_id => 8888, :day => Date.yesterday) }
      Tracker.update_to_current "Pacific Time (US & Canada)"
      Tracker.current.count.should == 100
    end
  end

  describe "scope :day_is_today" do
    it "returns all trackers with day =to today" do
      100.times { FactoryGirl.create :tracker, :day => Time.zone.today }
      50.times { FactoryGirl.create(:tracker, :day => Date.yesterday) }
    
      Tracker.count.should == 150
      Tracker.day_is_today('Pacific Time (US & Canada)').count.should == 100
    end
  end
  describe "::update_to_overdue" do
    it "updates trackers' :outcome to 'overdue' if in past" do
      100.times { Tracker.create :habit_id => 8888, :day => Time.zone.today }
      50.times { Tracker.create(:habit_id => 8888, :day => Date.yesterday) }
      Tracker.update_to_overdue('Pacific Time (US & Canada)')

      Tracker.overdue.count.should == 50
    end
  end
  describe "scope :day_is_past" do
    it "returns all trackers with :day in past" do
      100.times { FactoryGirl.create :tracker, :day => Time.zone.today }
      50.times { FactoryGirl.create :tracker, :day => Date.yesterday }
      Tracker.day_is_past('Pacific Time (US & Canada)').count.should == 50      
    end
  end
  describe "calendar" do
  
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

