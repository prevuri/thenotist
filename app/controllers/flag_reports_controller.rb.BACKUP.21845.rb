class FlagReportsController < ApplicationController
<<<<<<< HEAD
  def index
  	@unresolvedflagreports = FlagReport.where(:report_resolved => false)
    @resolvedflagreports = FlagReport.where(:report_resolved => true)
  end

  def create
  end

  def show
  end
end
=======
  before_filter :get_note_id, :only => [ :create ]

  def index
  	@flagreports = FlagReport.all
  end

  def create
  	# @flagreport = FlagReport.new(params[:flagreport])
  	# @flagreport.save
  	# redirect_to @flagreport
  	# # render text: params[:flagreport].inspect

  	# debugger
    
  	# @flagreport = FlagReport.create(:note => current_user.notes.find_by_id(@note_id))
    # @flagreport.save!
    # logger.info "*****************************"
    
    @note = Note.find_by_id(@note_id)
    @flagreport = @note.flag_reports.create
    redirect_to note_path(@note), :notice => "This note has been flagged"
  end

  def show
  	redirect_to :action => :index
  end

private
  def get_note_id
    @note_id = params[:note_id]
  end
end
>>>>>>> 716e00b3d99eeee3e5e16487fa5739584e7a5664
