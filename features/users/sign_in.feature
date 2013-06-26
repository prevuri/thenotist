Feature: Sign In
	In order to get access to the application
	A user
	should be able to sign in

	Scenario: User is not signed up
	Given I do not exist as a user
	When I sign in with valid credentials
	Then I should be signed in

	Scenario: User signs in successfully
	Given I exist as a user
	And I am not logged in
	When I sign in with valid credentials
	Then I should be signed in

	Scenario: User logs in with invalid credentials
	Given I exist as a user
	And I am not logged in
	When I sign in with invalid credentials
	Then I should be signed out