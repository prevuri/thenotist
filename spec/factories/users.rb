
#Factory user definition
FactoryGirl.define do
 factory :user do
    sequence(:name)  { |n| "Tester #{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end
end