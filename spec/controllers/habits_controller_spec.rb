require 'spec_helper'

describe HabitsController do
	describe "GET 'new'" do
		it "returns http success" do
			get :new, format: html
			response.should be_success
		end
	end
end
