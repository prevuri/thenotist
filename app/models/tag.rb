class Tag < ActiveRecord::Base
  attr_accessible :name
  belongs_to :note
  belongs_to :user

  default_scope where(:user_id => 1)#current_user.id)

  def as_json
    return {
      :name => name
    }
  end
end
