Given /^I am on the signup page$/ do
  visit signup_path
end

When /^I leave email blank$/ do
  click_button "Create User"
end

Then /^I should be on the signup page$/ do
  page.current_path.should == users_path
end

Then /^I should see an error message of "(.*)"$/ do |error|
	page.should have_content error
end

When /^I submit filled in form$/ do
  fill_in "Name", with: "Trevor"
	fill_in "Email", with: "me@here.com"
	fill_in "Password", with: "something"
	fill_in "Password confirmation", with: "something"
	click_button "Create User"
end

Then /^I should be on my users page$/ do
  page.current_path.should == user_path(1)
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content(text)
end

Given /^a user with email exists$/ do
	@user = FactoryGirl.create(:user)
end

When /^I fill in email with existing email$/ do
	fill_in "Name", with: "Trevor"
	fill_in "Email", with: @user.email
	fill_in "Password", with: "something"
	fill_in "Password confirmation", with: "something"
	click_button "Create User"

end
