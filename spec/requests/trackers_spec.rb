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

	describe "#index with calendar view" do
		context "habit not yet started" do
			it "has no link to tracking" do
				page.should_not have_css "tracking_link"
			end
		end
		context "habit started" do
			context "today" do
				before do
				click_button "Start Habit Now!!"
				click_link "tracking_link"
				end
				it "displays 21 trackers" do
					page.should have_css("article.tracker", count: 21)
				end
				it "displays 1 editable form" do
					page.should have_css("form.edit_tracker", count: 1)
				end
			end
			context "5 days ago" do
				before do
					click_button "Start Habit Now!!"
					Timecop.travel(Date.today + 5)
					click_link "tracking_link"
				end
				describe "with no forms submitted" do
					it "shows 6 forms" do
						page.should have_css("form.edit_tracker", count: 6)
					end
				end
				describe "with 2 forms submitted", js: :true do 
					it "shows 4 forms" do
						# click "click_pic"
						# click "click_pic"
						find("img.click_pic_good").click
						save_and_open_page
						find("img.click_pic_bad").click
						page.should have_css("form.edit_tracker", count: 4)
					end
				end
			end

		end
		context "habit completed" do
		end
	end



end