class NotesController < ApplicationController
  include NotesHelper
  before_filter :authenticate_user!
  before_filter :get_note_id, :except => [ :index, :create ]
  before_filter :abort_timed_out_notes
  layout false

  def index
    @notes = current_user.notes.select { |n| n.processed }
    @shared_notes = current_user.shared_notes
  end

  def create
    # don't allow a user to process more than one note at a time
    if current_user.has_note_processing?
      @fail_reason = "Can't upload more than one file at a time"
    else
      begin
        @note = current_user.notes.create(:title => "TestTitle", :description => "TestDescription")
        track_activity @note

        debugger
        s3_key = s3_key_from_filepath params[:filepath]
        queue = AWS::SQS.new.queues.named(ApplicationSettings.config[:sqs_pdf_conversion_queue_name])
        queue.send_message(sqs_message(@note.id, s3_key))
      rescue => ex
        @fail_reason = "unknown"
        @note.delete
        raise ex
      end
    end
  end

  def unsubscribe
    @note = current_user.shared_notes.find_by_id(@note_id)
    @note.revoke_share!(current_user)
    redirect_to notes_path, :notice => "You have unsubscribed from #{@note.title}"
  end

  def edit
    @note = current_user.notes.find_by_id(@note_id)
  end

  def show
    @note = current_user.notes.find_by_id(@note_id)
    @note = current_user.shared_notes.find_by_id(@note_id) unless @note
  end

  def update
    note = current_user.notes.find_by_id(@note_id)
    note.update_attributes(params[:note])

    redirect_to :action => :index
  end

  def destroy
    @note = current_user.notes.find_by_id(@note_id)
    @note.destroy
    redirect_to notes_path, :notice => "Note has been deleted"
  end

  def show_grid
    @note = current_user.notes.find_by_id(params[:id])
  end

private
  def get_note_id
    @note_id = params[:id]
  end

  def abort_timed_out_notes
    current_user.abort_timed_out_notes!
  end
end
