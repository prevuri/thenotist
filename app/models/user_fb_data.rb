class UserFbData < ActiveRecord::Base
  attr_accessible :link, :profile_image, :uid, :user_id
  belongs_to :user
end
