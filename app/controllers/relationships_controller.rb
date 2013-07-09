class RelationshipsController < ApplicationController
	before_filter :authenticate_user!
  def create
    @user = User.find(params[:relationship][:buddy_id])
    @relationship = current_user.follow!(@user)

    # track activity 
    track_activity @relationship

    respond_to do |format|
      format.html { redirect_to buddies_path }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).buddy
    current_user.unfollow!(@user)
    respond_to do |format| 
      format.html { redirect_to buddies_path }
      format.js
    end
  end
end
