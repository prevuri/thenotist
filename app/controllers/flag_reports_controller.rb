class FlagReportsController < ApplicationController
  def index
    debugger
  	@unresolvedflagreports = FlagReport.where(:report_resolved => false)
    @resolvedflagreports = FlagReport.where(:report_resolved => true)
  end

  def create
  end

  def show
  end
end