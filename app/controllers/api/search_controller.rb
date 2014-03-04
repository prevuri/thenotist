require 'set'
require 'fast_stemmer'

class Api::SearchController < ApplicationController
  include ApiHelper

  before_filter :check_authenticated_user!
  before_filter :get_search_query
  before_filter :validate_search_query

  UserInfo = Struct.new(:id, :name, :image)

  def search_notes
    table = AWS::DynamoDB.new.tables[ApplicationSettings.config[:ddb_one_word_reverse_index_table_name]]
    user_note_ids = current_user.notes.map &:id
    search_query = []
    @search_terms.each do |search_term|
      user_note_ids.each { |n_id| search_query << [search_term, n_id.to_s] }
    end

    search_results = table.batch_get(:all, search_query)
    parsed_search_results = search_results.map { |h| deserialize(h) }
    return render :json => {
      :success => true,
      :found => parsed_search_results
    }
  end

private
  def get_search_query
    raise "Search query must be present!" if params[:search_query].nil?
    @search_terms = params[:search_query].downcase.gsub(/[^0-9a-z ']/i, '').gsub(/\s+/m, ' ').strip.split(' ').uniq.to_set
    # stem
    @search_terms = @search_terms.map { |w| w.stem }.to_set
    # remove stop words
    @search_terms.subtract(ApplicationSettings.config[:stop_words])
    # remove ticks
    @search_terms = @search_terms.map { |w| w.gsub("'", '') }.to_set
    # remove 1 and 2-letter words
    @search_terms.select! { |k| k.length > 2 }
  end

  def validate_search_query
    raise "Search query must contain at least 3 characters!" unless @search_terms.length > 0
  end

  def deserialize h
    result = h.inject({}) { |mem, (k,v)| mem[k.to_sym] = v; mem }
    occurs = result[:occurrences].split("|")
    items = []
    occurs.each do |s|
      vals = s.split(",")
      items << { :page_num => vals[0].to_i, :line_num => vals[1].to_i, :word_pos => vals[2].to_i }
    end
    result[:occurrences] = items
    result[:count] = result[:count].to_i
    result[:note_id] = result[:note_id].to_i
    return result
  end
end
