class Api::TagsController < ApplicationController
  include ApiHelper

  before_filter :check_authenticated_user!
  before_filter :get_note

  def show
    return render :json => {
      :success => true,
      :tags => @note.tags.map &:as_json
    }
  end

  def update
    begin
      tags_h = params[:tags]
      tags = []
      tags_h.each do |t|
        tags << @note.tags.new :name => t[:name]
      end
      @note.tags.delete_all # only delete all old tags after we made sure we can create all new ones
      tags.each { |t| t.save }

      return render :json => {
        :success => true
      }
    rescue
      return render :json => {
        :success => false,
        :reason => "Could not update tags."
      }, :status => 500
    end
  end

private
  def get_note
    begin
      @note = current_user.notes.find params[:note_id]
    rescue
      return render :json => {
        :success => false,
        :reason => "Note not found."
      }, :status => 404
    end
  end
end
