class Api::NotesController < ApplicationController
  include ApiHelper

  before_filter :check_authenticated_user!
  before_filter :get_note, :only => [ :show, :update, :share, :unshare, :contribs, :destroy ]
  before_filter :get_note_title, :only => :update
  before_filter :get_note_description, :only => :update

  UserInfo = Struct.new(:id, :name, :image)

  def index
    return render :json => {
      :success => true,
      :notes => current_user.notes.map { |n| n.as_json }
    }
  end

  def show
    return render :json => {
      :success => true,
      :note => @note.as_json
    }
  end

  def update
    @note.update_attributes(@title) unless @title.nil?
    @note.update_attributes(@description) unless @description.nil?
    return render :json => {
      :success => true,
      :note => @note.as_json
    }
  end

  def destroy
    @note.destroy
    return render :json => {
      :success => true
    }
  end

  def contribs
    contribs = []
    @note.contributors.each do |contrib|
      contribs << UserInfo.new(contrib.user_id, contrib.user.name, contrib.user.user_fb_data.profile_image)
    end

    return render :json => {
      :success => true,
      :contributors => contribs
    }
  end

  def share
    begin
      @userstring = params[:userids]
      @useridstring = @userstring[1..@userstring.length - 2]
      @user_ids = @useridstring.split(",").map { |id| id.chomp('"').reverse.chomp('"').reverse}
      @users = []
      @user_ids.each do |user_id|
        @users << User.find_by_id(user_id)
      end
    
    rescue
      return render :json => {
        :success => false,
        :error => user_not_found_error + " " + @userstring
      }
    end
    #TODO: Set up multiple user activity

    begin 
      @users.each do |user|
        @contrib = @note.share!(user)
        track_activity @contrib
      end
    rescue
      return render :json => {
        :success => false,
        :error => already_shared_error
      }
    end

    return render :json => {
      :success => true,
      :note => @note.as_json
    }    
  end

  def unshare
    begin 
      @user = User.find_by_id(params[:userid])
    rescue
      return render :json => {
        :success => false,
        :error => user_not_found_error + " " + @user.name
      }
    end

    begin
      @note.revoke_share!(@user)
    rescue
      return render :json => {
        :success => false,
        :Error => cannot_revoke_error + " " + @user.name
      }
    end

    return render :json => {
      :success => true,
      :note => @note.as_json
    }

  end



private
  def get_note
    begin
      @note = current_user.notes.find(params[:id]) # throws an exception if nothing is found
    rescue
      return render :json => {
        :success => false,
        :error => note_not_found_error
      }
    end
  end

  def get_note_title
    @title = params[:title]
  end

  def get_note_description
    @description = params[:description]
  end

  def user_not_found_error
    "User not found :("
  end

  def already_shared_error
    "Already shared with user."
  end

  def cannot_revoke_error
    "Cannot remove contributor"
  end
end