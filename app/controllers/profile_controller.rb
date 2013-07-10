class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def index
	 @user = current_user
   @activities = current_user.activities
  end

  def show 
  	@user = User.find(params[:id])
  	render :index
  end

  def show
    user = User.find(params[:id])
    render 'index', :locals => { :current_user => user }
  end

  def feed
  	
  end
end
