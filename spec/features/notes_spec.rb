require 'spec_helper'

feature "Notes Page" do
	background  do
	   set_omniauth()
     visit root_path
	   click_on 'Connect with Facebook'
	end

  scenario "Index" do
    visit notes_path
  end
end
