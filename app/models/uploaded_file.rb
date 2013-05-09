class UploadedFile < ActiveRecord::Base
  attr_accessible :height, :page_number, :public_path, :type, :width

  belongs_to :note
  has_one :user, :through => :note
  has_many :comments

  def as_json options = {}
    {
      :id => id,
      :height => height,
      :width => width,
      :page_number => page_number,
      :public_path => public_path,
      :type => type,
      :created_at => created_at
    }
  end
end
