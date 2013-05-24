class Api::FilesController < ApplicationController
  include ApiHelper
  
  before_filter :check_authenticated_user!
  before_filter :get_note_id, :only => :index
  before_filter :get_file_id, :only => :show

  def index
    # TODO: delete this - it's only for testing
    u = User.first

    # TODO: change 'u' to 'current_user'
    begin
      @note = u.notes.find(@note_id) # throws an exception if nothing found
    rescue
      return render :json => {
        :success => false,
        :error => note_not_found_error
      }
    end

    @files = @note.uploaded_files
    return render :json => {
      :success => true,
      :files => @files.map { |f| f.as_json }
    }
  end

  def show
    # TODO: delete this - it's only for testing
    u = User.first

    # TODO: change 'u' to 'current_user'
    begin
      @file = u.uploaded_files.find(@uploaded_file_id) # throws an exception if nothing found
    rescue
      return render :json => {
        :success => false,
        :error => file_not_found_error
      }
    end

    return render :json => {
      :success => true,
      :file => @file.as_json
    }
  end

private
  def get_note_id
    @note_id = params[:note_id]
  end

  def get_file_id
    @uploaded_file_id = params[:id]
  end
end