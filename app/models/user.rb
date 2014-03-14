class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :fb_access_token, :remember_me, :provider, :uid

  has_one  :user_fb_data
  # has_many :fb_friends, dependent: :destroy
  has_many :activities
  has_many :notes
  has_many :uploaded_html_files, through: :notes
  has_many :comments
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :buddies, through: :relationships, source: :buddy
  has_many :buddy_activities, through: :buddies, source: :activities
  has_many :reverse_relationships, foreign_key: "buddy_id", class_name: "Relationship", dependent: :destroy
  # has_many :followers, through: :reverse_relationships, source: :follower
  has_many :contributed_to, class_name: "Contributor", dependent: :destroy
  has_many :shared_notes, through: :contributed_to
  has_many :shared_uploaded_html_files, through: :shared_notes, source: :uploaded_html_files


  def has_note_processing?
    self.notes.select { |n| !n.processed && !n.aborted }.count > 0
  end

  def following?(other_user)
    relationships.find_by_buddy_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(buddy_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_buddy_id(other_user.id).destroy
  end

  def self.new_with_session(params, session)
    super.tap do |user|
    	# puts user.email
    	if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    		user.email = data["email"] if user.email.blank?
    	end
	  end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    #Check if user already has provider logged in
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    #Brand new user using FB login
	  unless user
	    user = User.create(name:auth.extra.raw_info.name,
	                         provider:auth.provider,
	                         uid:auth.uid,
                           fb_access_token:auth.credentials.token,
                           email:auth.info.email.downcase,
	                         password:Devise.friendly_token[0,20]
	                         )

	  end

    #TODO: Update on last change: Check for a last change time
	  if user
      user.update_attribute(:fb_access_token, auth.credentials.token)

      #create a user_fb_data object knowing the access token is valid.
      @graph = Koala::Facebook::API.new(user.fb_access_token)
      profile = @graph.get_object(user.uid)
      profile_image = @graph.get_picture(user.uid, {:width => 300, :height => 300})
      friends = @graph.get_connections('me','friends',:fields=>"id")
      user.user_fb_data = UserFbData.create(uid:user.uid,
                                profile_image:profile_image,
                                link:profile["link"])

      # current_friends = FbFriend.find_all_by_user_id(user.id, :select => :uid).map &:uid
      # current_users = User.find_by_uid()
      friends.each do |friend|
        notist_friend = User.find_by_uid(friend["id"])
        if notist_friend != nil and !(user.buddies.include? notist_friend)
          user.follow!(notist_friend)
          notist_friend.follow!(user)
        end
      end
      user
    end
	end

  def as_json
    {
      :id => id,
      :name => name,
      :email => email,
      :member_since => created_at,
      :user_fb_data => user_fb_data.as_json,
      :notes => {:length => notes.length},
      :buddies => {:length => buddies.length}
    }
  end
end
