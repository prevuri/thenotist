class Api::UsersController < ApplicationController
  include ApiHelper

  before_filter :get_user, :only => [ :show, :buddies ]

  def index
    return render :json => {
      :success => true,
      :user => current_user.as_json
    }
  end

  def show
    return render :json => {
      :success => true,
      :user => @user.as_json
    }
  end

  def buddies
    return render :json => {
      :success => true,
      :buddies => @user.buddies.map(&:as_json)
    }
  end

private
  def get_user
    user_id = params[:id]
    @user = User.find(user_id)
    if @user.nil?
      return render :json => {
        :success => false,
        :reason => user_not_found_error
      }
    end
  end

  def user_not_found_error
    "User not found."
  end
end
