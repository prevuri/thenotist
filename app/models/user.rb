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
  has_many :notes
  has_many :contributing_notes, class_name: "Note"
  has_many :uploaded_files, through: :notes
  has_many :comments
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :buddies, through: :relationships, source: :buddy
  has_many :reverse_relationships, foreign_key: "buddy_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower


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

    #Check if the user has an account but has not logged in with provider
    unless user 
      user = User.find_by_email(auth.info.email.downcase)
      if user 
        user.update_attributes(name: auth.extra.raw_info.name, 
                             provider: auth.provider,
                             uid: auth.uid,
                             fb_access_token: auth.credentials.token,
                             )
      end
    end

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

	  if user
      user.update_attribute(:fb_access_token, auth.credentials.token)

      #create a user_fb_data object knowing the access token is valid.
      @graph = Koala::Facebook::API.new(user.fb_access_token)
      profile = @graph.get_object(user.uid)
      profile_image = @graph.get_picture(user.uid, {:width => 300, :height => 300})
      user.user_fb_data = UserFbData.create(uid:user.uid,
                                profile_image:profile_image,
                                link:profile["link"])
      
      user
    end
	end

  def as_json
    {
      :name => name,
      :email => email,
      :member_since => created_at
    }
  end
end
