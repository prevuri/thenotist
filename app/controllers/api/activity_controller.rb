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
    begin
      @user = User.find(params[:id])
    rescue
      render :json => {
        :success => true,
        :error => user_not_found_error
      }, :status => 404
    end
    render :json => {
      :success => true,
      :html => activity_html(@user.activities)
    }
  end

private
  def activity_html (activities)
    html = ""
    activities.order("created_at desc").each_with_index do |activity, i|
      html += render_to_string(:partial => 'main/activity', :object => activity)
      html += render_to_string(:partial => 'main/footer') if activities.count-1 == i
    end
    html
  end
end
