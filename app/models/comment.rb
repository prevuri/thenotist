include ActionView::Helpers::DateHelper

class Comment < ActiveRecord::Base

  attr_accessible :text, :line_id, :uploaded_html_file, :parent_comment
  belongs_to :uploaded_html_file
  belongs_to :user

  # this is done for optimization purpose when constructing queries for activities
  has_one :note_owner, :through => :uploaded_html_file, :source => :user
  has_one :note, :through => :uploaded_html_file

  belongs_to :parent_comment, :class_name => Comment
  has_many :child_comments, :class_name => Comment, :foreign_key => :parent_comment_id, :dependent => :destroy, :order => 'created_at ASC'

  # NOTE: JSON will only specify the ID of the parent comment,
  #       and will not render that as JSON to avoid circular dependencies
  def as_json options = {}
    {
      :id => id,
      :user => user.as_json,
      :owned_by_user => user == options[:current_user],
      :uploaded_html_file_id => uploaded_html_file.id,
      :text => text,
      :line_id => line_id,
      :parent_comment_id => parent_comment.nil? ? nil : parent_comment.id,
      :child_comments => child_comments.map { |c| c.as_json(:current_user => options[:current_user]) },
      :created_at => created_at,
      :time_string => distance_of_time_in_words(Time.now, created_at) + ' ago'
    }
  end
end
