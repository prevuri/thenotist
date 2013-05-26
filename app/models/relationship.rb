class Relationship < ActiveRecord::Base
  attr_accessible :blocked, :buddy_id
  belongs_to :follower, :class_name => "User"
  belongs_to :buddy, :class_name => "User"

  validates :follower_id, presence: true
  validates :buddy_id, presence: true
end
