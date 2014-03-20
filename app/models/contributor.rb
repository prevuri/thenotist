class Contributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :shared_note, class_name: "Note"
  attr_accessible :user_id, :shared_note_id
  validates :user_id, presence: true
  validates :shared_note_id, presence: true
end
