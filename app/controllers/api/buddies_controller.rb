class Api::BuddiesController < ApplicationController
  include ApiHelper
  UserInfo = Struct.new(:name, :image)
  def index
  	buds = Hash.new
  	current_user.buddies.each do |b|
  		buds[b.id] = UserInfo.new(b.name.to_s, b.user_fb_data.profile_image)
  	end
  	return render :json => buds
  end
end