require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector( 'h1', text: 'Sign Up') }
    it { should have_selector( 'title', text: full_title("Sign Up")) } 
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before do #{ visit user_path(user) }
      visit signin_path
      fill_in "Email", with: user.email 
      fill_in "Password", with: user.password 
      click_button "Sign in"
    end
    it "should have selector h2" do
      should have_selector('h2', text: user.name)
    end
    it { should have_selector('title', text: user.name) }
  end 

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create User" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",         with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Password confirmation",         with: "foobar"
      end
      it "should create a user" do
        save_and_open_page
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Thank you for signing up') }
      end
    end
  end
end
