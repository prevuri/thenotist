module ApiHelper
  # custom error messages
  def user_not_logged_in_error
    "No user currently logged in."
  end

  def note_not_found_error
    "File with id #{@note_id} not found"
  end

  def file_not_found_error
    "File with id #{@uploaded_file_id} not found"
  end


  # other methods
  def check_authenticated_user!
    if !current_user
      return render :json => {
        :success => false,
        :error => user_not_logged_in_error
      }
    end
  end
end