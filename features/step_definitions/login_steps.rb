Given /^I am a user$/ do
	@user = FactoryGirl.create :user
end
When /^I sign in$/ do
  visit  signin_path
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"
end

Then /^I should be on my home page$/ do
  page.current_path.should == user_path(@user)
end

When /^I sign in and leave email blank$/ do
	visit  signin_path
  fill_in "Password", with: @user.password
  click_button "Sign in"
end
When /^I sign in and leave password blank$/ do
	visit  signin_path
  fill_in "Email", with: @user.email
  click_button "Sign in"
end

Then /^I should be on the sign in page$/ do
	page.current_path.should == signin_path
end