class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def show
    user = User.find(params[:id])
    render 'index', :locals => { :current_user => user }
  end

  def feed
  	
  end
end
