class Api::ActivityController < ApplicationController
  include ApiHelper
  before_filter :check_authenticated_user!

  def index
    render :json => {
      :success => true,
      :html => activity_html(current_user.buddy_activities)
    }
  end

  def user
    render :json => {
      :success => true,
      :html => activity_html(current_user.activities)
    }
  end

  def show
    @user = User.find(params[:id])
    render :json => {
      :success => true,
      :html => activity_html(@user.activities)
    }
  end

private

  def activity_html (activities)
    html = ""
    activities.order("created_at desc").each do |activity|
      html += render_to_string(:partial => 'main/activity', :object => activity)
    end
    html
  end


end