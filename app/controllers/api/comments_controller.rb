class Api::CommentsController < ApplicationController
  include ApiHelper
  include CommentsHelper

  before_filter :check_authenticated_user!
  before_filter :get_uploaded_html_file_id, :only => [ :create ]
  before_filter :get_note_id, :only => [:index]
  before_filter :get_comment_id, :only => :destroy

  def index
    begin
      @note = current_user.notes.find(@note_id) # throws an exception if nothing found
    rescue
      begin
        @note = current_user.shared_notes.find(@note_id) # throws an exception if nothing found
      rescue
        return render :json => {
          :success => false,
          :error => note_not_found_error
        }, :status => 404
      end
    end

    # only render top-level comments, because their children will be rendered recursively
    return render :json => {
      :success => true,
      :comments => @note.parent_comments.map { |c| c.as_json(:current_user => current_user) }
    }
  end

  def create
    @file = current_user.uploaded_html_files.find_by_id(@uploaded_html_file_id) # does not throw an exception if nothing found
    @file = current_user.shared_uploaded_html_files.find_by_id(@uploaded_html_file_id) unless @file
    if @file.blank?
      return render :json => {
        :success => false,
        :error => file_not_found_error
      }, :status => 404
    end

    # now, construct all the attributes
    begin
      parent_comment = params[:comment][:parent_id].nil? ? nil : Comment.find(params[:comment][:parent_id])
      @comment = current_user.comments.create({
        :uploaded_html_file => @file,
        :text => params[:comment][:text],
        :line_id => params[:comment][:line_id],
        :parent_comment => parent_comment
      })

      # track the comment activity
      track_activity @comment
    rescue => ex
      return render :json => {
        :success => false,
        :error => comment_create_error
      }, :status => 500
    end

    # mirror the comments so that the UI can re-render the comments without having to make a separate
    # call to retrieve them
    @comments = @file.top_level_comments
    return render :json => {
      :success => true,
      :comments => @comments.map { |c| c.as_json(:current_user => current_user) }
    }
  end

  def destroy
    @comment = current_user.comments.find_by_id(@comment_id) # does not throw an exception if nothing found

    if @comment.blank?
      return render :json => {
        :success => false,
        :error => file_not_found_error
      }, :status => 404
    end

    # now, try to delete the comment
    begin
      destroy_activities_for_comment @comment

      @comment.child_comments.destroy_all
      @comment.destroy
    rescue => ex
      return render :json => {
        :success => false,
        :error => comment_create_error
      }, :status => 500
    end

    return render :json => {
      :success => true
    }
  end

private

  def get_note_id
    @note_id = params[:note_id]
  end

  def get_uploaded_html_file_id
    @uploaded_html_file_id = params[:file_id]
  end

  def get_comment_id
    @comment_id = params[:id]
  end
end
