class Api::FlagReportsController < ApplicationController
  include ApiHelper

  # before_filter :check_authenticated_user! # TODO: UNCOMMENT ME
  before_filter :get_note, :only => [ :create ]

  def index
    return render :json => {
      :success => true,
      :flag_reports => FlagReport.all.map { |n| n.as_json }
    }
  end

  def create
    begin
      @flagreport = @note.flag_reports.create
      return render :json => {
        :success => true
      }
    rescue
      return render :json => {
        :success => false,
        :error => flag_report_create_error
      }
    end
  end

private
  def get_note
    current_user = User.first # TODO: REMOVE ME
    begin
      @note = current_user.notes.find(params[:note_id]) # throws an exception if nothing is found
    rescue
      return render :json => {
        :success => false,
        :error => note_not_found_error
      }
    end
  end
end
