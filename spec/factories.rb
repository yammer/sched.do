FactoryGirl.define do
  sequence(:yammer_uid) { |n| "12345#{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:extra) { |n| { web_prefs: "prefs#{n}", expertise: "Rails#{n}" } }
  sequence(:yammer_image_url) { |n| "http://www.yammer.com/mugshot/48x48/#{n}" }
  sequence(:yammer_nickname) { |n| "Yams #{n}" }
  sequence(:yammer_profile_url) { |n| "http://www.yammer.com/example.com/users/#{n}" }
  sequence(:yammer_token) { |n| "token_#{n}" }
  sequence(:yammer_user_name) { |n| "Yammer User #{n}" }

  factory :user do
    name 'Joe'
    sequence(:access_token) { |n| "abc12#{n}" }
    sequence(:yammer_user_id) { |n| n.to_s }
    yammer_profile_url
  end

  factory :yammer_invitee do
    name 'Joe'
    sequence(:yammer_user_id) { |n| n.to_s }
  end

  factory :guest do
    email
  end

  factory :group do
    name 'Yammer Group'
    sequence(:yammer_group_id) { |n| n.to_s }
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
    user
  end

  factory :suggestion do
    primary 'A pretty good suggestion.'
    event
  end

  factory :invitation do
    event

    factory :invitation_with_user do
      association :invitee, factory: :user
      invitee_type 'User'
    end

    factory :invitation_with_group do
      association :invitee, factory: :group
      invitee_type 'Group'
    end

    factory :invitation_with_yammer_invitee do
      association :invitee, factory: :yammer_invitee
      invitee_type 'YammerInvitee'
    end

    factory :invitation_with_guest do
      association :invitee, factory: :guest
      invitee_type 'Guest'
    end
  end
end
