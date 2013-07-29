class UploadedFile < ActiveRecord::Base
  attr_accessible :height, :page_number, :public_path, :width, :thumb_url

  belongs_to :note
  has_one :user, :through => :note
  has_many :comments, :dependent => :destroy

  def top_level_comments
    comments.select { |c| c.parent_comment.nil? }
  end

  def as_json options = {}
    {
      :id => id,
      :height => height,
      :width => width,
      :page_number => page_number,
      :public_path => public_path,
      :created_at => created_at,
      :thumb_url => thumb_url
    }
  end
end
