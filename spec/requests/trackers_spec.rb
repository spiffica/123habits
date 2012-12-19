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
				# click_link "tracking_link"
			end
			context "with no failed days" do
				it "has 21 trackers" do
					# choose "tracker[success]"
					# click_button "Update Tracker"

					page.should have_css("article.tracker", count: 21)
				end
			end

			context "with one failed day" do
				it "has 28 trackers", js: true do
					find("img.click_pic_fail").click
					page.should have_css("article.tracker", count: 28)
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
				page.should_not have_css "a", text: "Progress"
			end
		end
		context "habit started" do
			context "today" do
				before do
					click_button "Start Habit Now!!"
					# click_link "tracking_link"
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
					# click_link "tracking_link"
				end
				describe "with no forms submitted" do
					it "shows 1 form" do
						page.should have_css("form.edit_tracker", count: 1)
					end
				end
				describe "with 2 forms submitted", js: :true do 
					before do
						find("img.click_pic_fail").click
						find("img.click_pic_fail").click
					end
					it "shows 1 form" do
						# click "click_pic"
						# click "click_pic"
						page.should have_css("form.edit_tracker", count: 1)
						page.should have_css("article.tracker", count: 35)
					end
					it "displays only one form" do
						page.should have_css("form.edit_tracker", count: 1)
					end
					it "displays 3 overdue trackers(yellow bg for now)" do
						page.should have_css("article.overdue", count: 3)
					end
					it "displays 1 current trackers(orange bg for now)" do
						page.should have_css("article.current", count: 1)
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
	describe "notes", js: true do
		before do
			click_button "Start Habit Now!!"
			# click_link "tracking_link"
			@tracker = @habit.trackers.first
			find("img.click_pic_fail").click
			@tracker.update_attribute(:notes, "It was a tough day")
			@note = @tracker.notes
		end
		context "with marked day" do
			it "has an image of a note as link to view/edit" do
				# page.should have_content("Notes")
				page.should have_css("a.notes_link")
			end
			it "displays contents of notes on hover" do
				page.should have_content("It was a tough day")
			end
			it "follows link to edit form for notes via js"
		end

	end



end