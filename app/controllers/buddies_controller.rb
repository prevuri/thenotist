class BuddiesController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@graph = Koala::Facebook::API.new(current_user.fb_access_token)
  	@friend_data = @graph.get_connections("me", "friends?fields=id,name,picture")
  	# @friends_using
  	# User.find(:all, :select => :uid).each do |user_id|
  	# 	@friends_data.each do |friend|
  			
  	# end
  	# puts @friend_pictures
  end
end
