Feature: Signing up 

	Scenario: Leaving a required element blank
		Given I am on the signup page
		When I leave email blank
		Then I should be on the signup page
		And I should see an error message of "can't be blank"

	Scenario: Signing up with email that has been taken
		Given a user with email exists
		And I am on the signup page
		When I fill in email with existing email
		Then I should see an error message of "has already been taken"

	Scenario: Successfully signing up
		Given I am on the signup page
		When I submit filled in form
		Then I should be on my users page
		And I should see "Account"
