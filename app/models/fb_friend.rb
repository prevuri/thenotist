class FbFriend < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :profile_image, :uid

  def as_json
    {
      :id => uid,
      :name => name,
      :image => profile_image
    }
  end
end
