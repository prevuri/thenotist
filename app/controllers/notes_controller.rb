class NotesController < ApplicationController
  before_filter :authenticate_user!
  def index
    @notes = current_user.notes
  end

  def create
    @note = current_user.notes.build(:title => params[:new_note][:title], :description => params[:new_note][:description])
    @images = @note.process(params[:new_note]) if params[:new_note]

    # defer the saving of everything until later in case things don't work out
    @note.save!
    @images.each do |img|
      img.save!
    end
  end

  def new
  end

  def edit
    @note = current_user.notes.find_by_id(params[:id])
  end

  def show
    @note = current_user.notes.find_by_id(params[:id])
  end

  def update
    note = current_user.notes.find_by_id(params[:id])
    note.update_attributes(params[:note])

    redirect_to :action => :index
  end

  def destroy
    @note = current_user.notes.find_by_id(params[:id])
    @note.destroy
    redirect_to notes_path, :notice => "Note has been deleted"
  end
end
