class NotesController < ApplicationController
  helper_method :flag_note
  before_filter :authenticate_user!
  before_filter :get_note_id, :except => [ :index, :create ]
  before_filter :abort_timed_out_notes

  def index
    @notes = current_user.notes.select { |n| n.processed }
    @shared_notes = current_user.shared_notes
  end

  def create
    # don't allow a user to process more than one note at a time
    if current_user.has_note_processing?
      @worker_started = false
      @fail_reason = "Can't upload more than one file at a time"
    else
      begin
        @note = current_user.notes.create(:title => params[:new_note][:title], :description => params[:new_note][:description])
        
        local_pdf_file = params[:new_note][:file].tempfile.path
        DocumentConversionWorker.perform_async({
          :current_user_id => current_user.id,
          :note_id => @note.id,
          :local_pdf_file => local_pdf_file
        })
        track_activity @note
        @worker_started = true
      rescue
        @worker_started = false
        @fail_reason = "unknown"
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
