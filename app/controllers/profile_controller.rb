class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def index
	@user = current_user
  end

  def show 
  	@user = User.find(params[:id])
  	render :index
  end

  def feed
  	
  end
end
