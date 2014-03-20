class AdminUsers < ActiveRecord::Base
  attr_accessible :name, :uid
  belongs_to :user

    def as_json
    {
      :name => name,
      :uid => uid
    }
  end

end
