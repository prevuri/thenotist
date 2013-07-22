class MainController < ApplicationController
  def index
    if !current_user
      render 'splash', :layout => 'minimal'
    else
      # Default action (render index)
    
      follow = current_user.followers.select { |f| !current_user.buddies.include? f }
      follow = follow.flatten

      buddy_act = current_user.buddy_activities

      if follow.empty?
        @activities = buddy_act
      else
        follow_act = []
        follow.each do |follower|
          follow_act << follower.activities.select { |a| (a.trackable_type == "Relationship" and a.trackable.buddy == current_user) }
        end
        follow_act.flatten!
        puts follow_act.last.user.name
        @activities = buddy_act + follow_act  

      end

      unless @activities.empty?
        @activities = @activities.sort_by { |act| act.created_at }
        @activities = @activities.reverse
      end
    end
  end
end
