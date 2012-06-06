FactoryGirl.define do
  sequence(:yammer_uid) { |n| "12345#{n}" }
  sequence(:yammer_user_name) { |n| "Yammer #{n}" }
  sequence(:yammer_token) { |n| "token_#{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    name 'Joe'
    sequence(:access_token) { |n| "abc12#{n}" }
    sequence(:yammer_user_id) { |n| n }
  end

  factory :event do
    name 'Clown party'
    user
  end

  factory :vote do
    suggestion
    user
  end

  factory :suggestion do
    description 'A pretty good suggestion.'
    event
  end
end
