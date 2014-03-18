class Tag < ActiveRecord::Base
  attr_accessible :name, :user
  belongs_to :note
  belongs_to :user

  def as_json
    return {
      :name => name
    }
  end
end
