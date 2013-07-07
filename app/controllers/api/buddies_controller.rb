class Api::BuddiesController < ApplicationController
  include ApiHelper
  def index
  	buds = Hash.new
  	current_user.buddies.each do |b|
  		buds[b.id] = b.name.to_s
  	end
  	return render :json => buds
  end
end