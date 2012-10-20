require 'spec_helper'

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
      before do
        # @habit.status = "started"
        # @habit.save
        click_link "I will"
        click_button "Start Habit Now!!"
      end
      describe "three bad days followed by 2 good days" do
        before do
          Timecop.travel 5.days
          @habit.trackers.count.should == 21
          3.times do |x|
            @habit.trackers[x-1].success = false
            @habit.trackers[x-1].save
          end
          2.times do |x|
            @habit.trackers[x+2].success = true
            @habit.trackers[x+2].save
          end
        end
        it "shows stats box on habit#show page" do
          @habit.trackers.success_days.count.should == 2
          page.should have_css "aside#stats"
        end
        it "displays streak of 2" do
          #TODO not working here, but working in actual
          within(:css, "aside#stats") do
            page.should have_css "#streak"
            @habit.trackers.pending.count.should == 19
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
  end
end
