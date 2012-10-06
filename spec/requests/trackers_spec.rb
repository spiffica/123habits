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
		context "habit has been started" do
			before do
				click_button "Start Habit Now!!"
				click_link "Tracking"
			end
			context "habit has not had any failed days" do
				it "has 21 trackers" do
					@habit.should have(21).trackers
				end
			end

			context "habit has had one failed day"
				it "has 28 trackers" do
					
		end
		context "habit has not yet started"
		context "habit is pending"
		context "habit is finished"

		it "displays 21 trackable days"
		context "unfilled past days" do
			it "displays yellow background"
			it "displays notice of uncharted days"
		end
	end



end