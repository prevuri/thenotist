class BuddiesController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@graph = Koala::Facebook::API.new(current_user.fb_access_token)
  	@friends_data = @graph.get_connections("me", "friends?fields=id,name,picture")
  	
  	@friends_using = []
  	index_hash = Hash[@friends_data.map.with_index.to_a]
  	
  	@removed_friends = []
  	User.all.each do |user|
  		@friends_data.each do |friend|
  			if friend["id"] == user.uid
  				@friends_using << friend
  				@removed_friends << index_hash[friend]
  			end
  		end
  	end

  	@friends_using.each do |using_friend|
  		@friends_data.delete_at(@removed_friends.pop)
  	end
  	# puts @friend_pictures
  end
end
