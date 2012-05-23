FactoryGirl.define do
  factory :user do
    name 'Joe'
    sequence(:access_token) { |n| "abc12#{n}" }
    sequence(:yammer_user_id) { |n| n }
  end
end
