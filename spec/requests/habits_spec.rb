require 'spec_helper'
# include Rails.application.routes.url_helpers

describe "Habits" do
  def add_habit
      visit root_path
      click_link "Create new habit"
      fill_in "Statement", with: "Eat breakfast"
      click_button "Create Habit"
  end
    
  let (:start_of_month) { Date.parse('1st July 2012') }
  before do
    Timecop.travel start_of_month
    @user = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user, email: "knob@here.com")
    visit signin_path
    fill_in "Email", with: @user.email 
    fill_in "Password", with: @user.password 
    click_button "Sign in"
  end
  describe "create new" do
    before do
      add_habit
    end
    it "sets new habit to pending " do
      page.should have_content("PENDING")
      page.should have_content("Eat breakfast")
      expect(Habit.count).to eq 1
    end
    it "redirects to Habit show path" do
      expect(current_path).to eq(habit_path(1))
    end
    it "allows user to start habit at anytime" do
      click_button "Start Habit"
      expect(Habit.first.status).to eq("started")
    end

    specify "delete" do
      click_link "View all habits" 
      expect{click_link "delete"}.to change{Habit.count}.by(-1)
    end
    specify "view" do
      click_link "View all habits"
      click_link "view"
      expect(current_path).to eq habit_path 1
    end
    context "three bad days followed by 2 good days" do
     before do
        click_button "Start Habit"
        Timecop.travel 5.days
        expect(Habit.first.statement).to eq "Eat breakfast"
        expect(Habit.first.status).to eq "started"
        3.times do 
          choose "tracker_outcome_fail"
          click_button "Submit"
        end
        2.times do 
          choose "tracker_outcome_pass"
          click_button "Submit"
        end
      end
      it "calculates 2 passing days" do
        # save_and_open_page
        Habit.first.trackers.pass.count.should == 2
        page.should have_css "table.stats"
      end
      it "shows stats box on habit#show page" do
        Habit.first.trackers.pass.count.should == 2
        page.should have_css "table.stats"
        # save_and_open_page
      end
      it "displays streak of 2" do
        # Date.today.should == "July 6"
        within(:css, "table.stats") do
          page.should have_content "Streak"
          Habit.first.trackers.unmarked.count.should == 37
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


    it "doesn't allow access to other users habits" do
    @habit2 = FactoryGirl.create(:habit, user: @user2)

    visit user_path(@user2)
    page.should_not have_content(@habit2.statement)
    end

      

    describe "when habit is completed" do
      before do
        click_button "Start Habit Now!!"
        Timecop.travel Habit.first.end_date
        21.times do
          choose "tracker_outcome_pass"
          click_button "Submit"
        end
      end
      it "responds to status" do
        Habit.first.should respond_to :status
      end
      it "changes status to completed when last day successful" do
        page.should have_content "COMPLETED"
        Habit.first.id.should eq 1
        Habit.first.status.should == 'completed'
        Habit.first.completed_date.should == Time.now.to_date
        Habit.first.completed?.should == true
      end
      it "gives a congratulatory message" do
        page.should have_content "Congratulations"
      end
      describe "and in monitor mode" do
        before do 
          click_button 'Keep Tracking Habit'
        end
        it "adds 21 trackers to habit only if status is 'completed'" do
          Habit.first.trackers.count.should == 42
          page.should_not have_content "Keep Tracking Habit"
        end
        it "changes status to 'monitoring'" do
          Habit.first.status.should == 'monitoring'
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
