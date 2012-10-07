require 'spec_helper'

describe "Trackers" do
	before do
		@user = FactoryGirl.create(:user)
		@habit = FactoryGirl.create(:habit, user: @user)
		sign_in @user
		click_link "I will"
	end
	it "shows Tracking button" do
		page.should have_content "Tracking"
	end
	it "follows link to Tracking view" do
		click_link "Tracking"
		page.should have_content "Progress for \"#{@habit.statement}\""
	end

	describe "#index" do
		describe "habit has been started" do
			before do
				click_button "Start Habit Now!!"
				click_link "Tracking"
			end
			context "with no failed days" do
				it "has 21 trackers" do
					# choose "tracker[success]"
					click_button "Update Tracker"

					page.should have_css("li.tracker", count: 21)
				end
			end

			context "with one failed day" do
				it "has 28 trackers" do
					choose "fail"
					click_button "Update Tracker"
					page.should have_css("li.tracker", count: 28)
				end
			end
			context "if completed", js: true do
				it "shows history of all trackers used" do
					choose "fail"
					click_button "Update Tracker"
					click_link "I will"
					click_link "edit"
					choose "completed"
					click_button "Update Habit"
					click_link "Tracking"
					page.should have_css("li.tracker", count: 28)
				end
			end
		end

		describe "habit has not yet started" do
			it "shows no trackers" do
				page.should_not have_css("li.tracker")
			end
		end
		


		context "unfilled past days" do
			it "displays yellow background"
			it "displays notice of uncharted days"
		end
	end



end