class Comment < ActiveRecord::Base
  default_scope order('ycoord ASC')

  attr_accessible :text, :ycoord, :uploaded_file
  belongs_to :uploaded_file
  belongs_to :user

  after_create :track_activity
  before_destroy :destroy_activity

  def as_json options = {}
    {
      :id => id,
      :user => user.as_json,
      :uploaded_file_id => uploaded_file.id,
      :text => text,
      :ycoord => ycoord,
      :created_at => created_at
    }
  end

private
  def track_activity
  end
  def destroy_activity

  end
end
