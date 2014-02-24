class Api::ActivityController < ApplicationController
  include ApiHelper
  before_filter :check_authenticated_user!

  def index
    html = ""
    current_user.activities.order("created_at desc").each do |activity|
      html += render_to_string(:partial => 'main/activity', :object => activity)
    end
    render :json => {
      :success => true,
      :html => html
    }
  end

end