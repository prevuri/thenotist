class MainController < ApplicationController
  def index
    if !current_user
      render 'splash', :layout => 'minimal'
    else
      # Default action (render index)
    end
  end
end
