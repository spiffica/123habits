require 'spec_helper'

describe "Static pages" do

  let( :base_title) { "Habit Buster" }

  describe "Home page" do
    it "should have the content 'Stop Smoking NOW!!!'" do
      visit '/static_pages/home'
      page.should have_selector('h1', text: 'Stop Smoking NOW!!!')
    end
    it "should have the right title" do 
      visit '/static_pages/home'
      page.should have_selector('title', text: "#{base_title}")
    end
    it "should not have custom page title 'Home'" do 
      visit '/static_pages/home'
      page.should_not have_selector('title', text: "| Home")
    end

  end

  describe "Help page" do
    it "should have the content 'FAQ's'" do
      visit '/static_pages/help'
      page.should have_selector('h1', text: 'FAQ\'s')
    end
    it "should have the right title" do 
      visit '/static_pages/help'
      page.should have_selector('title', text: "#{base_title} | Help")
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', text: 'About Us')
    end
    it "should have the right title" do 
      visit '/static_pages/about'
      page.should have_selector('title', text: "#{base_title} | About Us")
    end
  end
end
