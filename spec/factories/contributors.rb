# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contributor do
    user nil
    shared_note_id 1
  end
end
