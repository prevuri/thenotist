class Comment < ActiveRecord::Base
  attr_accessible :text, :ycoord, :uploaded_file
  belongs_to :uploaded_file
  belongs_to :user

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
end
