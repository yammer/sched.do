FactoryGirl.define do
  sequence(:yammer_uid) { |n| "12345#{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:extra) { |n| { raw_info: { network_id: 1 }, expertise: "Rails#{n}" } }
  sequence(:image) { |n| YAMMER_HOST + "/mugshot/48x48/#{n}" }
  sequence(:yammer_nickname) { |n| "Yams #{n}" }
  sequence(:yammer_profile_url) { |n| YAMMER_HOST + "/example.com/users/#{n}" }
  sequence(:yammer_token) { |n| "token_#{n}" }
  sequence(:yammer_user_name) { |n| "Yammer User #{n}" }

  factory :activity_creator do
    initialize_with {
      new(
        build_stubbed(:user),
        'create',
        build_stubbed(:event)
      )
    }
  end

  factory :event do
    name 'Clown party'
    owner(factory: :user)

    before :create do |event|
      event.suggestions << build(:suggestion, event: event)
    end

    after :stub do |event|
      event.generate_uuid
    end

    factory :event_with_invitees do
      after :create do |event|
        event.guests << build(:guest)
        event.users << build(:user)
      end
    end
  end

  factory :group do
    name 'Yammer Group'
    sequence(:yammer_group_id) { |n| n.to_s }
  end

  factory :guest do
    email
    sequence(:name) { |n| "Joe Guest #{n}" }
  end

  factory :suggestion do
    primary 'A pretty good suggestion.'
    event
  end

  factory :reminder do
    sender factory: :user
    receiver factory: :event
  end

  factory :invitation do
    event
    association :invitee, factory: :user
    association :sender, factory: :user
    invitee_type 'User'
    sender_type 'User'

    factory :invitation_with_user do
      association :invitee, factory: :user
      invitee_type 'User'
    end

    factory :invitation_with_group do
      association :invitee, factory: :group
      invitee_type 'Group'
    end

    factory :invitation_with_guest do
      association :invitee, factory: :guest
      invitee_type 'Guest'
    end
  end

  factory :user do
    sequence(:name) { |n| "Joe User #{n}" }
    email
    sequence(:access_token) { |n| "abc12#{n}" }
    sequence(:yammer_user_id) { |n| n.to_s }
    image
    yammer_profile_url
    yammer_network_id 1

    factory :out_network_user do
      yammer_network_id 2
    end
  end

  factory :vote do
    suggestion
    association :voter, factory: :user

    factory :guest_vote do
      association :voter, factory: :guest
    end
  end
end
