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

		context "pending past days" do
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
					it "shows 1 form" do
						page.should have_css("form.edit_tracker", count: 1)
					end
				end
				describe "with 2 forms submitted", js: :true do 
					before do
						find("img.click_pic_bad").click
						find("img.click_pic_bad").click
					end
					it "shows 1 form" do
						# click "click_pic"
						# click "click_pic"
						page.should have_css("form.edit_tracker", count: 1)
						page.should have_css("article.tracker", count: 23)
					end
					it "displays only one form" do
						page.should have_css("form.edit_tracker", count: 1)
					end
					it "displays 3 pending trackers(yellow bg for now)" do
						page.should have_css("article.pending", count: 3)
					end
					it "redirects to #show" do
						pending
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