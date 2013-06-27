# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_fb_datum, :class => 'UserFbData' do
    user_id 1
    uid "MyString"
    profile_image "MyString"
    link "MyString"
  end
end
