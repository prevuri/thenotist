class BuddiesController < ApplicationController
  before_filter :authenticate_user!
  def index
  	@friends_using = get_fb_data
  	# puts @friend_pictures
  end

  def buddies
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.buddies.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def get_fb_data
    @graph = Koala::Facebook::API.new(current_user.fb_access_token)
    @friends_data = @graph.get_connections("me", "friends?fields=id,name,picture")
    
    @friend_notists = []
    index_hash = Hash[@friends_data.map.with_index.to_a]
    
    @removed_friends = []
    User.all.each do |user|
      @friends_data.each do |friend|
        if friend["id"] == user.uid
          @removed_friends << index_hash[friend]
          friend.merge!({:id => user.id})
          @friend_notists << friend
        end
      end
    end

    @friend_notists.each do |using_friend|
      @friends_data.delete_at(@removed_friends.pop)
    end
  end
end
