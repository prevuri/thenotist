class UploadedFile < ActiveRecord::Base
  attr_accessible :height, :note_id, :page_number, :public_path, :type, :width
  belongs_to :note
end
