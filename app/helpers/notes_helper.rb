module NotesHelper
  require 'uri'
  require 'yaml'

  def s3_key_from_filepath path
    result = URI.unescape(path)
    result = result[1..result.length-1] if result[0] == '/'
    tokens = result.split('/')
    tokens = tokens[1..tokens.length-1]
    return tokens.join('/')
  end

  def sqs_message note_id, s3_key
    return {
      :note_id => note_id,
      :s3_key => s3_key,
      :s3_bucket_name => ApplicationSettings.config[:s3_bucket_name],
      :output_html_prefix => ApplicationSettings.config[:output_html_prefix],
      :output_css_prefix => ApplicationSettings.config[:output_css_prefix],
      :output_thumb_prefix => ApplicationSettings.config[:output_thumb_prefix]
    }.to_yaml
  end

  def destroy_activities_for_note note
    search_query = "(trackable_id=#{note.id} AND trackable_type='Note')"
    note.comments.each do |c|
      search_query += " OR "
      search_query += "(trackable_id=#{c.id} AND trackable_type='Comment')"
    end
    note.contributors.each do |c|
      search_query += " OR "
      search_query += "(trackable_id=#{c.id} AND trackable_type='Contributor')"
    end

    activities = Activity.where(search_query)
    activities.destroy_all unless activities.blank?
  end

end
