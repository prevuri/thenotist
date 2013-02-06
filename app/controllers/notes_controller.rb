class NotesController < ApplicationController
  def index
  end

  def create
    note = current_user.notes.create(:title => params[:notes][:description], :description => params[:notes][:description])
    @images = note.process(params[:notes]) if params[:notes]

    redirect_to notes_path, :notice => 'Note has been created'
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
