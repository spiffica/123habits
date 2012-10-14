require 'spec_helper'

describe "Trackers" do
	let (:start_of_month) { Date.parse('1st July 2012') }
	before do
		@user = FactoryGirl.create(:user)
		@habit = FactoryGirl.create(:habit, user: @user)
		sign_in @user
		click_link "I will"
		Timecop.travel start_of_month
	end

	describe "#index" do
		describe "habit has been started" do
			before do
				click_button "Start Habit Now!!"
				click_link "tracking_link"
			end
			context "with no failed days" do
				it "has 21 trackers" do
					# choose "tracker[success]"
					# click_button "Update Tracker"

					page.should have_css("article.tracker", count: 21)
				end
			end

			context "with one failed day" do
				it "has 22 trackers", js: true do
					find("img.click_pic_bad").click
					page.should have_css("article.tracker", count: 22)
				end
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
					Timecop.travel(start_of_month + 5.days)
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
						find("img.click_pic_bad").click
						find("img.click_pic_bad").click
						page.should have_css("form.edit_tracker", count: 4)
						page.should have_css("article.tracker", count: 23)
					end
					# it "shows modal containing tracker info when 'article' clicked" do
					# 	find("img.click_pic_bad").click
					# 	find("img.article").click

					# 	page.should 
					# end
					it "redirects to #show" do
						@tracker = @habit.trackers.first
						find("article.tracker").click

						current_path.should eq habit_tracker_path(@habit, @tracker)
					end


				end

			end

		end
		context "habit completed" do
		end
	end



end