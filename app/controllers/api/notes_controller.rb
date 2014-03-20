class Api::NotesController < ApplicationController
  include ApiHelper
  include NotesHelper

  before_filter :check_authenticated_user!
  before_filter :get_note, :only => [ :show, :update, :share, :unshare, :unsubscribe, :contribs, :destroy, :paginate ]
  before_filter :get_note_title, :only => [:create, :update]
  before_filter :get_page_range, :only => [ :paginate ]
  # before_filter :abort_timed_out_notes, :only => [ :index ]

  UserInfo = Struct.new(:id, :name, :image)

  def index
    @notes = current_user.notes + current_user.shared_notes
    return render :json => {
      :success => true,
      :notes => @notes.map { |n| n.as_json_for_index(current_user) }
    }
  end

  def create
    begin
      @note = current_user.notes.create(:title => @title)
      track_activity(@note)

      s3_key = params[:s3_key]
      queue = AWS::SQS.new.queues.named(ApplicationSettings.config[:sqs_pdf_conversion_queue_name])
      queue.send_message(sqs_message(@note.id, s3_key))
      return render :json => {
        :success => true,
        :noteId => @note.id
      }
    rescue => ex
      @fail_reason = "unknown"
      @note.destroy
      return render :json => {
        :success => false,
        :error_message => ex.message
      }, :status => 500
    end
  end

  def show
    return render :json => {
      :success => true,
      :note => @note.as_json(current_user)
    }
  end

  def update
    @note.update_attributes(:title => @title) unless @title.nil?
    return render :json => {
      :success => true,
      :note => @note.as_json(current_user)
    }
  end

  def destroy
    destroy_activities_for_note(@note)
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

  def usernotes
    @user = User.find_by_id(params[:id])
    @notes = @user.notes + @user.shared_notes
    return render :json => {
      :success => true,
      :all_notes_count => @notes.count,
      :notes => @notes.map { |n| n.as_json_for_index(current_user) }
    }
  end

  def share
    begin
      @user = current_user.buddies.find(params[:userid])

    rescue
      return render :json => {
        :success => false,
        :error => user_not_found_error + " " + @userstring
      }
    end

    begin
      @contrib = @note.share!(@user)
      track_activity @contrib
    rescue
      return render :json => {
        :success => false,
        :error => already_shared_error
      }
    end

    return render :json => {
      :success => true,
      :note => @note.as_json(current_user)
    }
  end

  def unshare
    begin
      @user = current_user.buddies.find_by_id(params[:userid])
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
      :note => @note.as_json(current_user)
    }
  end


  def unsubscribe
    begin
      @note.revoke_share!(current_user)
    rescue
      return render :json => {
        :success => false,
        :Error => cannot_revoke_error + " " + @user.name
      }
    end

    return render :json => {
      :success => true
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
      begin
        @note = current_user.shared_notes.find(params[:id]) # throws an exception if nothing is found
      rescue
        return render :json => {
          :success => false,
          :error => note_not_found_error,
        },
        :status => 404
      end
    end
  end

  def get_note_title
    @title = params[:title]
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

  # def abort_timed_out_notes
  #   current_user.notes.each &:abort_if_timed_out!
  # end
end
