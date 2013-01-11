require 'spec_helper'

describe TrackerManager do
	it "requires habit object in init"
	describe "#create_initial_trackers" do
		it "creates 21 new trackers for this habit" do
			@habit = FactoryGirl.create(:habit)
			TrackerManager.new(@habit).create_initial_trackers
			expect(Tracker.count).to eql 21
		end
	end
end