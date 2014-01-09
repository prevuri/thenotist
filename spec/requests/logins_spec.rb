require 'spec_helper'

feature "Facebook Login" do
	
	scenario "Good Login" do
 		visit root_path
   		set_omniauth()
   		click_on 'Connect with Facebook'
   		expect(page).to have_content 'Successfully authenticated from Facebook account.'
	end

	scenario "Bad Credentials" do
		visit root_path
   		set_invalid_omniauth()
   		click_on 'Connect with Facebook'
   		expect(page).to have_content 'Connect with Facebook'
	end
end

feature "Unauthenticated Profile Page Acess Denial" do
	scenario "Index" do
		visit profile_index_path
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "Id" do
		visit profile_path(1)
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "New" do
		visit new_profile_path
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "Edit" do
		visit edit_profile_path(1)
   		expect(page).to have_content 'Connect with Facebook'
	end
end

feature "Unauthenticated Note Page Acess Denial" do
	scenario "Index" do
		visit notes_path
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "Id" do
		visit note_path(1)
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "New" do
		visit new_note_path
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "Edit" do
		visit edit_note_path(1)
   		expect(page).to have_content 'Connect with Facebook'
	end

	scenario "Unsubscribe" do
		visit unsubscribe_note_path(1)
   		expect(page).to have_content 'Connect with Facebook'
	end
end

feature "Unauthenticated Buddies Page Denial" do
	scenario "Index" do
		visit buddies_path
   		expect(page).to have_content 'Connect with Facebook'
   	end
end

feature "Unauthenticated API Page Denial" do

end