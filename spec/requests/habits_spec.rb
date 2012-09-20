require 'spec_helper'

describe "Habits" do
  context "with logged in user" do 
  	before do
	      @user = FactoryGirl.create(:user)
	      @user2 = FactoryGirl.create(:user, email: "knob@here.com")
	      @habits = FactoryGirl.create(:habit, user: @user)
	      @habits2 = FactoryGirl.create(:habit, user: @user2)
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
    	page.should_not have_content(@habits2.statement)
    end

  end
end
