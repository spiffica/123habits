require 'spec_helper'
# include Rails.application.routes.url_helpers

describe "Habits" do
  let (:start_of_month) { Date.parse('1st July 2012') }
  context "with logged in user" do 
    before do
        Timecop.travel start_of_month
	      @user = FactoryGirl.create(:user)
	      @user2 = FactoryGirl.create(:user, email: "knob@here.com")
	      @habit = FactoryGirl.create(:habit, user: @user)
	      @habit2 = FactoryGirl.create(:habit, user: @user2)
	      visit signin_path
	      fill_in "Email", with: @user.email 
	      fill_in "Password", with: @user.password 
	      click_button "Sign in"
	  end
    it "shows list of users habits" do
      page.should have_content("I will stop 1")
    end
    it "doesn't allow access to other users habits" do
    	visit user_path(@user2)
    	page.should_not have_content(@habit2.statement)
    end

    context "with one habit started" do
      #NOTE these all work individually; not sure what the problem is
      before do
        click_link "I will stop 1"
        click_button "Start Habit Now!!"
      end
      describe "progress bar" do
        before do
          visit root_path
        end
        it "is displayed" do
          save_and_open_page
          page.should have_css("progress")
        end
      end
      describe "three bad days followed by 2 good days" do
        before do
          Timecop.travel 5.days
          @habit.trackers.count.should == 21
          3.times do 
            choose "tracker_outcome_fail"
            click_button "Submit"
          end
          2.times do 
            choose "tracker_outcome_pass"
            click_button "Submit"
          end
        end
        it "shows stats box on habit#show page" do
          @habit.trackers.pass.count.should == 2
          page.should have_css "table.stats"
          save_and_open_page
        end
        it "displays streak of 2" do
          # Date.today.should == "July 6"
          within(:css, "table.stats") do
            page.should have_content "Streak"
            @habit.trackers.unmarked.count.should == 37
            page.should have_content("2 days")
          end
        end
        it "displays percent success" do
          pending
        end
        it "displays date started" do
          pending
        end
        it "displays end date" do
          pending
        end
      end
    end
    describe "when habit is completed" do
      before do
        click_link "Create new habit"
        fill_in "Statement", with: "Quit wasting"
        click_button "Create Habit"
        click_button "Start Habit Now!!"
        @my_habit = Habit.find_by_statement "Quit wasting"
        Timecop.travel @my_habit.end_date
        21.times do
          choose "tracker_outcome_pass"
          click_button "Submit"
        end
        save_and_open_page
      end
      it "responds to status" do
        @my_habit.should respond_to :status
      end
      it "allows status to be changed" do
        @my_habit.status = 'monitor'
        @my_habit.save
        @my_habit.status.should == 'monitor'
      end
      it "changes status to completed when last day successful" do
        page.should have_content "COMPLETED"
        @my_habit.status.should == 'completed'
        @my_habit.completed_date.should == Time.now.to_date
        #above works proving below should too!!..but not
        @my_habit.completed?.should == true
      end
      it "gives a congratulatory message" do
        page.should have_content "Congratulations"
      end
    
      it "gives option to keep monitoring habit" do
        page.should have_css("a", text: "Keep Tracking Habit")
      end
      context "and in monitor mode" do
        before do 
          click_link 'Keep Tracking Habit'
        end
        it "adds 21 trackers to habit only if status is 'completed'" do
          @my_habit.trackers.count.should == 42
          page.should_not have_content "Keep Tracking Habit"
        end
        it "changes status to 'monitoring'" do
          #as line 94, not working in test
          @my_habit.status.should == 'monitoring'
        end
        it "displays 'completed on ___ in _status" do 
          page.should have_content "COMPLETED"
        end
        it "displays 'Still Monitoring' in _status" do
          page.should have_content "Still monitoring habit"
        end
      end
    end
  end
end

