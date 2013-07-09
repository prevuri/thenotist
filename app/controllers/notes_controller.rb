class NotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_note_id, :except => [ :index, :create ]
  def index
    @notes = current_user.notes
    @shared_notes = current_user.shared_notes
  end

  def create
    @note = current_user.notes.build(:title => params[:new_note][:title], :description => params[:new_note][:description])
    @images = @note.process(params[:new_note]) if params[:new_note]
    # defer the saving of everything until later in case things don't work out
    @note.save!
    @images.each do |img|
      img.save!
    end

    track_activity @note
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
end
