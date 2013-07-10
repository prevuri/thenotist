class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def track_activity(trackable, action = params[:action])
  	current_user.activities.create! action: action, trackable: trackable
  end

  def destroy_activity(activity)
    current_user.activities.destroy activity
  end
end
