class Api::NotesController < ApplicationController
  include ApiHelper
  include NotesHelper

  before_filter :check_authenticated_user!
  before_filter :get_note, :only => [ :show, :update, :share, :unshare, :contribs, :destroy, :paginate ]
  before_filter :get_note_title, :only => :update
  before_filter :get_note_description, :only => :update
  before_filter :get_page_range, :only => [ :paginate ]
  before_filter :abort_timed_out_notes

  UserInfo = Struct.new(:id, :name, :image)

  def index
    return render :json => {
      :success => true,
      :notes => current_user.notes.map { |n| n.as_json }
    }
  end

  def create
    # don't allow a user to process more than one note at a time
    if current_user.has_note_processing?
      @fail_reason = "Can't upload more than one file at a time"
    else
      begin
        @note = current_user.notes.create(:title => params[:title], :description => params[:description])
        track_activity @note

        s3_key = params[:s3_key]
        queue = AWS::SQS.new.queues.named(ApplicationSettings.config[:sqs_pdf_conversion_queue_name])
        queue.send_message(sqs_message(@note.id, s3_key))
        return render :json => {
          :success => true
        }
      rescue => ex
        @fail_reason = "unknown"
        @note.delete
        return render :json => {
          :success => false,
          :error_message => ex.message
        }
      end
    end


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

  def upload_form_html
    render :json => {
      :success => true,
      :html => render_to_string(:partial => 'notes/s3_upload_form')
    }
  end

  def paginate
    html_files = @note.uploaded_html_files.where(:page_number => [@start_page..@end_page])
    return render :json => {
      :success => true,
      :html_files => html_files.map(&:as_json)
    }
  end

private
  def get_note
    begin
      @note = current_user.notes.find(params[:id]) # throws an exception if nothing is found
    rescue
      return render :json => {
        :success => false,
        :error => note_not_found_error,
      },
      :status => 404
    end
  end

  def get_note_title
    @title = params[:title]
  end

  def get_note_description
    @description = params[:description]
  end

  def get_page_range
    @start_page = params[:start_page]
    @end_page = params[:end_page]
    if @start_page.nil? && @end_page.nil?
      return render :json => {
        :success => false,
        :error => invalid_page_range_error
      }
    end

    num_pages = @note.uploaded_html_files.count
    @start_page ||= 0
    @end_page ||= num_pages-1
    @start_page = @start_page.to_i
    @end_page = @end_page.to_i
    if @end_page < @start_page || @start_page > num_pages-1 || @end_page < 0
      return render :json => {
        :success => false,
        :error => invalid_page_range_error
      }
    end
  end

  def user_not_found_error
    "User not found."
  end

  def already_shared_error
    "Already shared with user."
  end

  def cannot_revoke_error
    "Cannot remove contributor."
  end

  def invalid_page_range_error
    "Invalid page range."
  end

  def abort_timed_out_notes
    current_user.abort_timed_out_notes!
  end
end
