class Api::UploadedFilesController < ApplicationController
  # before_filter :authenticate_user!

  before_filter :get_uploaded_file_id, :only => [ :index, :create ]
  before_filter :get_comment_id, :only => :destroy

  def index
    # TODO: delete this - it's only for testing
    u = User.first
    # TODO: change 'u' to 'current_user'
    begin
      @file = u.uploaded_files.find(@uploaded_file_id) # throws an exception if nothing found
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
    # TODO: delete this - it's only for testing
    u = User.first
    # TODO: change 'u' to 'current_user'
    @file = u.uploaded_files.find_by_id(@uploaded_file_id) # does not throw an exception if nothing found

    if @file.blank?
      return render :json => {
        :success => false,
        :error => uploaded_file_not_found_error
      }
    end

    # now, construct all the attributes
    begin
      # TODO: change 'u' to 'current_user'
      u.comments.create ({
        :uploaded_file => @file, 
        :text => params[:comment][:text], 
        :ycoord => params[:comment][:ycoord]
      })
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
      :comments => @comments.map { |c| c.as_json }
    }
  end

  def destroy
    # TODO: delete this - it's only for testing
    u = User.first
    # TODO: change 'u' to 'current_user'
    @comment = u.comments.find_by_id(@comment_id) # does not throw an exception if nothing found

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
    @comments = u.comments
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

  def uploaded_file_not_found_error
    "File with id #{@uploaded_file_id} not found"
  end

  def comment_create_error
    "Could not create comment with supplied parameters"
  end

  def comment_not_found_error
    "Comment with id #{@comment_id} not found"
  end

  def comment_destroy_error
    "Could not destroy comment with id #{@comment_id}"
  end
end