class UserFbData < ActiveRecord::Base
  attr_accessible :link, :profile_image, :uid, :user_id
  belongs_to :user

  def as_json
    {
      :link => link,
      :profile_image => profile_image
    }
  end
end
