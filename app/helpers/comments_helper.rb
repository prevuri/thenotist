module CommentsHelper
  def destroy_activities_for_comment comment
    search_query = "(trackable_id=#{comment.id} AND trackable_type='Comment')"
    comment.child_comments.each do |c|
      search_query += " OR "
      search_query += "(trackable_id=#{c.id} AND trackable_type='Comment')"
    end

    activities = Activity.where(search_query)
    activities.destroy_all unless activities.blank?
  end

end
