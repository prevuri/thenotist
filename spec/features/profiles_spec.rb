require 'spec_helper'

feature "Profile Page" do
	background  do
	   set_omniauth()
     visit root_path
	   click_on 'Connect with Facebook'
	end

  scenario "Index" do
    visit profile_index_path
  end
end
