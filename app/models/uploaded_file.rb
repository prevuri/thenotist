class UploadedFile < ActiveRecord::Base
  attr_accessible :height, :page_number, :public_path, :type, :width

  belongs_to :note
  has_one :user, :through => :note
  has_many :comments
end
