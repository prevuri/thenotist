def set_omniauth(opts = {})
  default = {:provider => :facebook,
             :uuid     => "1234",
             :facebook => {
                            :email => "foobar@example.com",
                            :gender => "Male",
                            :first_name => "foo",
                            :last_name => "bar"
                          }
            }
 
  credentials = default.merge(opts)
  provider = credentials[:provider]
  user_hash = credentials[provider]
 
  OmniAuth.config.test_mode = true
 
  OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
    :provider => provider,
    :uid => "1234",
    :extra => OmniAuth::AuthHash.new({
      :raw_info => OmniAuth::AuthHash.new({
          :email => user_hash[:email],
          :first_name => user_hash[:first_name],
          :last_name => user_hash[:last_name],
        })
    }),
    :info => OmniAuth::AuthHash::IfnoHash.new({

    }),

  })
end
 
def set_invalid_omniauth(opts = {})
 
  credentials = { :provider => :facebook,
                  :invalid  => :invalid_crendentials
                 }.merge(opts)
 
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]
 
end


#<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash expires=true expires_at=1377386189 token="CAAE2AxZCHe3oBADTdISosZBtozJ7mMcH7wCRCxQQZClqmEBCsFLbWZANkW0jxO9Bgxyni1kXkY35ngImgj2ZB8KLXGRyM4XcQZC95oiXrVHs6m65ZCWYe7YMCsde7krpTnPGvkjjT9VitDG3tyozaA2"> extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash email="betty_kxdumsa_bushak@tfbnw.net" first_name="Betty" gender="female" id="100005982036528" last_name="Bushak" link="http://www.facebook.com/profile.php?id=100005982036528" locale="en_US" middle_name="Ameih" name="Betty Ameih Bushak" timezone=-4 updated_time="2013-05-27T21:50:29+0000">> info=#<OmniAuth::AuthHash::InfoHash email="betty_kxdumsa_bushak@tfbnw.net" first_name="Betty" image="http://graph.facebook.com/100005982036528/picture?type=square" last_name="Bushak" name="Betty Ameih Bushak" urls=#<OmniAuth::AuthHash Facebook="http://www.facebook.com/profile.php?id=100005982036528">> provider="facebook" uid="100005982036528">