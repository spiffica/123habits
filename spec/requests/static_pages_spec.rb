require 'spec_helper'

describe "Static pages" do

  let( :base_title) { "Habit Buster" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector( sel, text: heading) }
    it { should have_selector( 'title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:sel) { 'h2' }
    let(:heading) { '...where habits go to die!!'}
    let(:page_title) { "" }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: "| Home") }
  end

  describe "Help page" do
    before { visit help_path }
    let(:sel) { 'h1' }
    let(:heading) { "FAQ's" }
    let(:page_title) { "Help" }

    it_should_behave_like "all static pages"

  end

  describe "About page" do
    before { visit about_path }
    let(:sel) { 'h1' }
    let(:heading) { "About Us" }
    let(:page_title) { "About Us" }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout"  do 
    visit root_path
    click_link "About"
    page.should have_selector('title', text: full_title('About Us')) 
    click_link "Help"
    page.should have_selector('title', text: full_title('Help')) 
    click_link "Home"
    page.should have_selector('title', text: full_title('')) 
    click_link "Sign Up Now"
    page.should have_selector('h1', text: 'Sign Up')

  end
end
