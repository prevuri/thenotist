class Api::CommentsController < ApplicationController
  include ApiHelper

  before_filter :check_authenticated_user!
  before_filter :get_uploaded_file_id, :only => [ :index, :create ]
  before_filter :get_comment_id, :only => :destroy

  def index
    begin
      @file = current_user.uploaded_files.find(@uploaded_file_id) # throws an exception if nothing found
    rescue
      return render :json => {
        :success => false,
        :error => uploaded_file_not_found_error
      }
    end

    @comments = @file.comments
    return render :json => {
      :success => true,
      :comments => @comments.map { |c| c.as_json }
    }
  end

  def create
    @file = current_user.uploaded_files.find_by_id(@uploaded_file_id) # does not throw an exception if nothing found
    @file = current_user.shared_uploaded_files.find_by_id(@uploaded_file_id) unless @file
    if @file.blank?
      return render :json => {
        :success => false,
        :error => uploaded_file_not_found_error
      }
    end

    # now, construct all the attributes
    begin
      @comment = current_user.comments.create({
        :uploaded_file => @file, 
        :text => params[:comment][:text], 
        :ycoord => params[:comment][:ycoord]
      })

      # track the comment activity
      track_activity @comment
    rescue
      return render :json => {
        :success => false,
        :error => comment_create_error
      }
    end

    # mirror the comments so that the UI can re-render the comments without having to make a separate
    # call to retrieve them
    @comments = @file.comments
    return render :json => {
      :success => true,
      :comments_html => render_to_string(:partial => "notes/comments", :object => @comments)
    }
  end

  def destroy
    @comment = current_user.comments.find_by_id(@comment_id) # does not throw an exception if nothing found

    if @comment.blank?
      return render :json => {
        :success => false,
        :error => uploaded_file_not_found_error
      }
    end

    # now, try to delete the comment
    begin
      @comment.destroy
    rescue
      return render :json => {
        :success => false,
        :error => comment_create_error
      }
    end

    # mirror the comments so that the UI can re-render the comments without having to make a separate
    # call to retrieve them
    @comments = current_user.comments
    return render :json => { 
      :success => true,
      :comments => @comments.map { |c| c.as_json }
    }
  end

private
  def get_uploaded_file_id
    @uploaded_file_id = params[:file_id]
  end

  def get_comment_id
    @comment_id = params[:id]
  end
end