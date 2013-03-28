class Comment < ActiveRecord::Base
  attr_accessible :text, :ycoord
  belongs_to :uploaded_file
  has_one :user, :through => :uploaded_file

  def as_json options = {}
    {
      :id => id,
      :user => user.as_json,
      :uploaded_file_id => uploaded_file.id,
      :text => text,
      :ycoord => ycoord
    }
  end
end
