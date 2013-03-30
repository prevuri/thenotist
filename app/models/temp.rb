class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :sq_image, :s_image, :image, :l_image, :email, :password, :password_confirmation, :fb_access_token, :remember_me, :provider, :uid
  # attr_accessible :title, :body
  has_many :notes

  def self.new_with_session(params, session)
    super.tap do |user|
    	# puts user.email
    	if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    		user.email = data["email"] if user.email.blank?
    	end
	  end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    puts auth
	  
    #Get all the image sizes for use
    def_image = auth.info.image
    base_image_url = def_image[0, def_image.rindex('?')+1]
    large_image = base_image_url + "type=large"
    small_image = base_image_url + "type=small"
    normal_image = base_image_url + "type=normal"

    #Check if user already has provider logged in
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    #Check if the user has an account but has not logged in with provider
    unless user 
      user = User.find_by_email(auth.info.email)
      if user 
        user.update_attributes(:name => auth.extra.raw_info.name, 
                             :provider => auth.provider,
                             :uid => auth.uid,
                             :fb_access_token => auth.credentials.token,
                             :sq_image => def_image,
                             :s_image => small_image,
                             :l_image => large_image,
                             :image => def_image)
      end
    end

    #Brand new user using FB login
	  unless user
	    user = User.create(name:auth.extra.raw_info.name,
	                         provider:auth.provider,
	                         uid:auth.uid,
                           fb_access_token:auth.credentials.token,
                           sq_image:def_image,
                           s_image:small_image,
                           l_image:large_image,
                           image:auth.info.image,
	                         email:auth.info.email,
	                         password:Devise.friendly_token[0,20]
	                         )
	  end

	  if user
      user
    end
	end
end
