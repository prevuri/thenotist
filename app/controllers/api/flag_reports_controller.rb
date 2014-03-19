class Api::FlagReportsController < ApplicationController
  include ApiHelper

  # before_filter :check_authenticated_user! # TODO: UNCOMMENT ME
  before_filter :get_type, :get_note, :get_description, :only => [ :create ]
  before_filter :get_report, :get_resolved, :only => [ :update ]

  def index
    return render :json => {
      :success => true,
      :flag_reports => FlagReport.all.map { |n| n.as_json },
      :unresolvedflagreports => FlagReport.where(:report_resolved => false).map { |n| n.as_json },
      :resolvedflagreports => FlagReport.where(:report_resolved => true).map { |n| n.as_json }
    }
  end

  def create
    begin
      @note.flag_reports.create(:user => current_user, :report_resolved => false, :description => @description, :report_type => @type)
      @note.update_attributes :flagged => true
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

  def update
    @report.update_attributes :report_resolved => @resolved
    @report.note.update_attributes :flagged => !@resolved
    return render :json => {
      :success => true
    }
  end

private
  def get_type
    @type = params[:report_type]
  end
  def get_description
    @description = params[:report_description]
  end
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

  def get_report
    @report = FlagReport.find(params[:id])
    if @report.blank?
      return :json => {
        :success => false,
        :reason => "Could not find report."
      }, :status => 404
    end
  end

  def get_resolved
    @resolved = params[:resolved]
    if @resolved.blank?
      return :json => {
        :success => false,
        :reason => "Request must include a resolved field."
      }, :status => 400
    end
  end
end
