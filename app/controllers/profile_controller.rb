class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@graph = Koala::Facebook::API.new(current_user.fb_access_token)
	@profile = @graph.get_object("me")
	@profile_image = @graph.get_picture("me", {:width => 300, :height => 300})
	puts @profile
  end
end
