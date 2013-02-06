class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private
  def current_user
    # TODO: change this to the actual logged in user
    @current_user ||= User.first
  end
end
