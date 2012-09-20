require 'spec_helper'

describe "Reasons" do
  describe "test javascript" do
  	before do
  		@user = FactoryGirl.create(:user)
  		@habit = FactoryGirl.create(:habit, user:@user)
  		visit signin_path
  		fill_in "Email", with: @user.email 
      fill_in "Password", with: @user.password 
      click_button "Sign in"	
      click_link "I will"	

  	end
    it "click tab Reasons", js:true do
    	page.should have_content("Reasons")
    	click_button "Create Reason"
    	page.should have_content("can't be blank")
    end
    it "creates new reason",js:true do
    	fill_in "reason_message", with: "Because I want to"
    	click_button "Create Reason"
    	page.should have_selector('span#message')
    	click_link "edit_reason"
    	page.should have_content "Edit Reason"
    	fill_in "reason_message", with: "New and improved"
    	click_button "Update Reason"
    	page.should have_content "New and improved"
    	page.should_not have_content "Because I want to"
    	click_link "delete"
    	sleep 2
    	# page.should_not have_content "New and improved"
    	page.should_not have_selector('span#message')
    end
    # it "follows the edit link to modal", js:true do
    # 	within 'ul#list_reasons' do 
	   #  end
    # end
  end
end
