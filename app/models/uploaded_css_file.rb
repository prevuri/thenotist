class UploadedCssFile < ActiveRecord::Base
  attr_accessible :public_path
  belongs_to :note
  has_one :user, :through => :note

	def as_json options = {}
	{
	  :id => id,
	  :public_path => public_path
	}
	end
end
