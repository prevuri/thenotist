class RelationshipsController < ApplicationController
	before_filter :authenticate_user!
  def create
  	debugger
    @user = User.find(params[:relationship][:buddy_id])
    current_user.follow!(@user)
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
