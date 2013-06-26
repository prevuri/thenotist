Feature: Sign In
	In order to get access to the application
	A user
	should be able to sign in

	Scenario: User is not signed up
	Given I do not exist as a user
	When I sign in with valid credentials
	Then I should be signed in

	Scenario: User signs up successfully
	Given I exist as a user
	And I am not logged in
	When I sign in with valid credentials
	Then I should be signed in
	And I should see a successful sign in message

	# Scenario: User enters incorrect email
	# Given I exist as a user
	# And I am not logged in
	# When I sign in with the wrong email
	# Then I should see an invalid login message
	# And I should be signed out

	# Scenario: User enters incorrect password
	# Given I exist as a user
	# And I am not logged in
	# When I sign in with the wrong password
	# Then I should see an invalid login message
	# And I should be signed out