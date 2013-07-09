class MainController < ApplicationController
  def index
    if !current_user
      render 'splash', :layout => 'minimal'
    else
      # Default action (render index)
      unless current_user.buddies.empty?
        @activities = current_user.buddy_activities
      end
    end
  end
end
