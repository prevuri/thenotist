class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def index
	 @user = current_user
   @activities = current_user.activities.order("created_at desc")
   temp = 0
  end

  def show 
  	@user = User.find(params[:id])
    @activities = @user.activities.order("created_at desc")
  	render :index
  end

  def feed
  	
  end
end
