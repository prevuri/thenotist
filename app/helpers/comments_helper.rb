module CommentsHelper
  def destroy_activities_for_comment comment
    all_comments = all_children_recursive(comment)
    search_query = ""
    all_comments.each_with_index do |c, i|
      search_query += "(trackable_id=#{c.id} AND trackable_type='Comment')"
      search_query += " OR " unless i == all_comments.length-1
    end

    activities = Activity.where(search_query)
    activities.destroy_all unless activities.blank?
  end

  def all_children_recursive parent
    stack = [parent]
    all_items = []
    while !stack.empty? do
      elem = stack.pop
      all_items << elem
      stack.concat(elem.child_comments)
    end
    return all_items
  end
end
