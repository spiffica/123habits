Feature: Login
	Scenario: Successful login
		Given I am a user
		When I sign in
		Then I should be on my home page

	Scenario: Blank email
		Given I am a user
		When I sign in and leave email blank
		Then I should be on the sign in page
	Scenario: Blank password
		Given I am a user
		When I sign in and leave password blank
		Then I should be on the sign in page
