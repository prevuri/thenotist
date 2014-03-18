class Api::ActivityController < ApplicationController
  include ApiHelper
  before_filter :check_authenticated_user!

  def index

    @activities = current_user.buddy_activities + current_user.activities
    # @activities.flatten
    render :json => {
      :success => true,
      :html => activity_html(@activities)
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
    activities.sort_by(&:created_at).each_with_index do |activity, i|
      html += render_to_string(:partial => 'main/activity', :object => activity)
      html += render_to_string(:partial => 'main/footer') if activities.count-1 == i
    end
    html
  end
end
