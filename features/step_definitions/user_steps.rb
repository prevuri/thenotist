def create_visitor
	@visitor ||= { :name => "Testy Tasticles", :email => "testy@example.com", :password => "changeme", :password_confirmation => "changeme"}
end

def find_user
	@user ||= User.where(:email => @visitor[:email]).first
end

def delete_user
	@user ||= User.where(:email => @visitor[:email]).first
	@user.destroy unless @user.nil?
end

def create_user
	create_visitor
	delete_user
	@user = FactoryGirl.create(:user, @visitor)
end

def sign_up
	delete_user
	visit '/users/sign_up'
	fill_in 'user_email', :with => @visitor[:email]
	fill_in 'user_password', :with => @visitor[:password]
	fill_in 'user_password_confirmation', :with => @visitor[:password_confirmation]
	click_button 'Sign Up'
	find_user
end

def sign_in 
	visit '/users/sign_in'
	fill_in 'user_email', :with => @visitor[:email]
	fill_in 'user_password', :with => @visitor[:password]
	click_button 'Sign In'
end

def sign_in_fb
	visit '/'
	set_omniauth()
	click_link 'Connect with Facebook'
end

def sign_in_fb_invalid
	visit '/'
	set_invalid_omniauth()
	click_link 'Connect with Facebook'
end



##GIVENS##
Given /^I am logged in$/ do
	create_user
	sign_in_fb
end

Given /^I am not logged in$/ do
	visit '/users/sign_out'
end

Given /^I exist as a user$/ do
	create_user
end

Given /^I do not exist as a user$/ do
	create_visitor
	delete_user
end

##WHENS##
When /^I sign in with valid credentials$/ do 
	create_visitor
	sign_in_fb
end

When /^I sign in with invalid credentials$/ do 
	create_visitor
	sign_in_fb_invalid
end

When /^I sign out$/ do
	visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
	create_visitor
	sign_up
end

When /^I sign up with an invalid email$/ do
	create_visitor
	@visitor = @visitor.merge(:email => 'notavalidemail')
	sign_up
end

When /^I sign up without an email$/ do
	create_visitor
	@visitor = @visitor.merge(:email => '')
	sign_up
end

When /^I sign up without a password$/ do
	create_visitor
	@visitor = @visitor.merge(:password => '')
	sign_up
end

When /^I sign up without a password confirmation$/ do
	create_visitor
	@visitor = @visitor.merge(:password_confirmation => '')
	sign_up
end

When /^I sign up with the wrong password confirmation$/ do
	create_visitor
	@visitor = @visitor.merge(:password_confirmation => 'wrongpass')
	sign_up
end

When /^I sign in with the wrong email$/ do
	create_visitor
	@visitor = @visitor.merge(:email => 'wrong@example.com')
	sign_in_fb
end

When /^I sign in with the wrong password$/ do
	create_visitor
	@visitor = @visitor.merge(:password => 'wrongpass')
	sign_in_fb
end

When /^I edit my email$/ do
	visit '/users/edit'
	fill_in 'user_email', :with => "newemail@example.com"
	fill_in 'user_current_password', :with => @visitor[:password]
	click_button 'Update'
end

When /^I edit my password$/ do
	visit '/users/edit'
	fill_in 'user_password', :with => "newpassword"
	fill_in 'user_password_confirmation', :with => "newpassword"
	fill_in 'user_current_password', :with => @visitor[:password]
	click_button 'Update'
end

##THENS##

Then /^I should be signed in$/ do
	page.should_not have_content "Login"
	page.should_not have_content "Sign up"
	#page.should have_content @user[:name] Not valid without facebook.
end

Then /^I should be signed out$/ do
	page.should have_content "Login"
	page.should have_content "Sign up"
	page.should_not have_content "Logout"
end

Then /^I should see a successful facebook sign in message$/ do 
	page.should have_content "Successfully authenticated from Facebook account."
end

Then /^I should see a successful sign in message$/ do
	page.should have_content "Signed in successfully"
end

Then /^I should see a successful sign up message$/ do
	page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid login message$/ do
	page.should have_content "Invalid email or password."
end

Then /^I should see a missing email message$/ do
	page.should have_content "Email can't be blank"
end

Then /^I should see a missing password message$/ do
	page.should have_content "Password can't be blank"
end

Then /^I should see an invalid email message$/ do
	page.should have_content "Please enter an email address"
end

Then /^I should see an invalid password confirmation message$/ do
	page.should have_content "Password doesn't match confirmation"
end




