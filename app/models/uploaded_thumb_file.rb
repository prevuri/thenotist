class UploadedThumbFile < ActiveRecord::Base
  attr_accessible :note_id, :page_number, :public_path
  belongs_to :note
  has_one :user, :through => :note

  def as_json
    {
      :id => id,
      :public_path => public_path,
      :page_number => page_number
    }
  end
end
