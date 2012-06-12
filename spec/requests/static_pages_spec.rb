require 'spec_helper'

describe "Static pages" do

  let( :base_title) { "Habit Buster" }

  describe "Home page" do
    it "should have the content 'Stop Smoking NOW!!!'" do
      visit '/static_pages/home'
      page.should have_content('Stop Smoking NOW!!!')
    end
    it "should have the right title" do 
      visit '/static_pages/home'
      page.should have_selector('title', text: "#{base_title} | Home")
    end
  end

  describe "Help page" do
    it "should have the content 'FAQ's'" do
      visit '/static_pages/help'
      page.should have_content('FAQ\'s')
    end
    it "should have the right title" do 
      visit '/static_pages/help'
      page.should have_selector('title', text: "#{base_title} | Help")
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
    it "should have the right title" do 
      visit '/static_pages/about'
      page.should have_selector('title', text: "#{base_title} | About Us")
    end
  end
end
