require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    it "should have the content 'Stop Smoking NOW!!!'" do
      visit '/static_pages/home'
      page.should have_content('Stop Smoking NOW!!!')
    end
    it "should have the right title" do 
      visit '/static_pages/home'
      page.should have_selector('title', text: "Habit Buster | Home")
    end
  end

  describe "Help page" do
    it "should have the content 'FAQ's'" do
      visit '/static_pages/help'
      page.should have_content('FAQ\'s')
    end
    it "should have the right title" do 
      visit '/static_pages/help'
      page.should have_selector('title', text: "Habit Buster | Help")
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
    it "should have the right title" do 
      visit '/static_pages/about'
      page.should have_selector('title', text: "Habit Buster | About Us")
    end
  end
end
