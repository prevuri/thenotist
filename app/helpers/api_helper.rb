module ApiHelper
  # custom error messages
  def user_not_logged_in_error
    "No user currently logged in."
  end

  def note_not_found_error
    "File with id #{@note_id} not found"
  end

  def file_not_found_error
    "File with id #{@uploaded_html_file_id} not found"
  end

  def uploaded_html_file_not_found_error
    "File with id #{@uploaded_html_file_id} not found"
  end

  def comment_create_error
    "Could not create comment with supplied parameters"
  end

  def comment_not_found_error
    "Comment with id #{@comment_id} not found"
  end

  def comment_destroy_error
    "Could not destroy comment with id #{@comment_id}"
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
