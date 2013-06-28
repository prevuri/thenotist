class MainController < ApplicationController
  def index
    if !current_user
      render 'splash', :layout => 'minimal'
    else
      # Default action (render index)
      @activities = Activity.order("created_at desc")
    end
  end
end
