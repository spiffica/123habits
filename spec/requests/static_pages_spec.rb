require 'spec_helper'

describe "Static pages" do

  let( :base_title) { "Habit Buster" }

  describe "Home page" do
    before { visit root_path }
    subject { page }
      it { should have_selector('h2', text: '...where habits go to die!!') }
      it { should have_selector('title', text: full_title("")) }
      it { should_not have_selector('title', text: "| Home") }

  end

  describe "Help page" do
    before { visit help_path }
    subject { page }
      it { should have_selector('h1', text: 'FAQ\'s') }
      it { should have_selector('title', text: full_title("Help")) }
  end

  describe "About page" do
    before { visit about_path }
    subject { page }
      it { should have_selector('h1', text: 'About Us') }
      it { should have_selector('title', text: full_title("About Us")) }
  end
end
