class MainController < ApplicationController
  def index
    if !current_user
      render 'splash', :layout => 'minimal'
    else
      # Default action (render index)
      @activities = []
     unless current_user.buddies
     	@activities << current_user.buddies.first.activities

      	current_user.buddies.each do |buddy|
      		unless buddy == current_user.buddies.first
      			(@activities << buddy.activities).flatten
      		end
      	end

      	@activities = @activities.order("created_at desc")
      end

    end
  end
end
