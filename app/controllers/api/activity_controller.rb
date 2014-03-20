class Api::ActivityController < ApplicationController
  include ApiHelper
  before_filter :check_authenticated_user!

  def index
    # @activities = current_user.buddy_activities + current_user.activities
    @activities = current_user.allowed_activities(current_user)
    render :json => {
      :success => true,
      :html => activity_html(@activities)
    }
  end

  def user
    render :json => {
      :success => true,
      :html => activity_html(current_user.allowed_activities(current_user))
    }
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue
      render :json => {
        :success => true,
        :error => user_not_found_error
      }, :status => 404
    end
    render :json => {
      :success => true,
      :html => activity_html(@user.allowed_activities(current_user))
    }
  end

private
  def activity_html (activities)
    groups = group_activities(activities)
    html = ""
    groups.each_with_index do |group, i|
      html += render_to_string(:partial => 'main/activity', :locals => { :group => group })
      html += render_to_string(:partial => 'main/footer') if groups.count-1 == i
    end
    html
  end

  def group_activities activities
    return [] if activities.blank?
    remaining_activities = activities
    grouped = []
    all_contribs = remaining_activities.select { |a| a.trackable_type.downcase == 'contributor' }
    uniq_note_ids = all_contribs.map{|a|a.trackable.shared_note_id}.uniq
    uniq_note_ids.each do |i|
      contribs_for_note = all_contribs
        .select { |a| a.trackable.shared_note_id == i }
        .uniq { |a| a.trackable.user_id }
        .sort_by(&:created_at)
        .reverse
      grouped << build_activity_group(contribs_for_note)
      remaining_activities -= contribs_for_note
    end

    grouped.concat(remaining_activities.map { |a| build_activity_group([a])})
    return grouped
  end

  # assuming that all activities in the group are of the same type (e.g. contributor)
  def build_activity_group group
    return {
      :time => group.max{ |a| a.created_at.to_i }.created_at,
      :type => group.first.trackable_type,
      :activities => group,
      :user_id => group.first.user.id,
      :profile_image => group.first.user.user_fb_data.profile_image,
      :class => group.first.trackable.class.name.downcase
    }
  end
end
