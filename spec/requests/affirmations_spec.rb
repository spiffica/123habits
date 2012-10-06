require 'spec_helper'

describe "Affirmations" do
	before do
		@user = FactoryGirl.create(:user)
		@habit = FactoryGirl.create(:habit, user: @user)
  	# @aff = FactoryGirl.create(:affirmation, habit: @habit)

	end
  describe "modal" do
  	before do
  		sign_in @user
  		click_link "#{@habit.statement}"
  	end
  	it "has a tab heading named 'Affirmations'" do
  		page.should have_content("Affirmations")
  	end
  	it "lists affirmations", js:true do
  		click_link "Affirmations"
  		fill_in "affirmation_message", with: "This I affirm"
  		click_button  "Create Affirmation"
  		page.should have_content "This I affirm"
  	end

  	it "creates new affirmation" do
  		click_link "Affirmations" 
  		fill_in "affirmation_message", with: "I am great"
  		expect {
        click_button "Create Affirmation"
        }.to change(Affirmation, :count).by(1)
    end

    it "new affirmation updates count on screen", js:true do
      click_link "Affirmations" 
      fill_in "affirmation_message", with: "I am great"
      click_button "Create Affirmation"
      page.should have_content "Affirmations(1)"
    end

    it "deletes affirmation", js:true do
      click_link "Affirmations" 
      fill_in "affirmation_message", with: "I am great"
      click_button "Create Affirmation"
      click_link "delete"

      page.should_not have_content "I am great"
      page.should have_content "Affirmations(0)"
    end

    it "updates affirmation", js:true do
      click_link "Affirmations" 
      fill_in "affirmation_message", with: "I am great"
      click_button "Create Affirmation"
      within ".affirmation" do
        click_link "edit"
      end

      page.should have_content "Edit Affirmation"

      fill_in "affirmation_message", with: "I am very great"
      click_button "Update Affirmation"

      page.should have_content "I am very great"
      page.should have_content "Affirmations(1)"

    end
    
  end
end
