class Comment < ActiveRecord::Base

  attr_accessible :text, :line_id, :uploaded_file, :parent_comment
  belongs_to :uploaded_file
  belongs_to :user

  belongs_to :parent_comment, :class_name => Comment
  has_many :child_comments, :class_name => Comment, :foreign_key => :parent_comment_id, :dependent => :destroy

  after_create :track_activity
  before_destroy :destroy_activity

  # NOTE: JSON will only specify the ID of the parent comment, 
  #       and will not render that as JSON to avoid circular dependencies
  def as_json options = {}
    {
      :id => id,
      :user => user.as_json,
      :uploaded_file_id => uploaded_file.id,
      :text => text,
      :line_id => line_id,
      :parent_comment_id => parent_comment.nil? ? nil : parent_comment.id,
      :child_comments => child_comments.map { |c| c.as_json },
      :created_at => created_at
    }
  end

private
  def track_activity
  end

  def destroy_activity
  end
end
