FactoryGirl.define do
  sequence(:yammer_uid) { |n| "12345#{n}" }
  sequence(:yammer_user_name) { |n| "Yammer #{n}" }
  sequence(:yammer_token) { |n| "token_#{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    name 'Joe'
    sequence(:access_token) { |n| "abc12#{n}" }
    sequence(:yammer_user_id) { |n| n.to_s }
  end

  factory :guest do
    initialize_with { new(name: 'Bruce Wayne', email: generate(:email)) }
  end

  factory :event do
    name 'Clown party'
    user
  end

  factory :vote do
    suggestion
    association :votable, factory: :user_vote

    factory :vote_by_user do
      ignore do
        user { create(:user) }
      end

       after :create do |vote, evaluator|
         vote.votable.update_attribute(:user, evaluator.user)
       end
    end
  end

  factory :user_vote do
    user
  end

  factory :guest_vote do
    name 'Bruce Wayne'
    email
  end

  factory :suggestion do
    description 'A pretty good suggestion.'
    event
  end

  factory :invitation do
    name 'Bob Invite'
    event

    factory :invitation_with_user do
      user
    end
  end
end
