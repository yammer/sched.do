FactoryGirl.define do
  sequence(:yammer_uid) { |n| "12345#{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:extra) { |n| { raw_info: { network_id: 1 }, expertise: "Rails#{n}" } }
  sequence(:image) { |n| "https://mug0.assets-yammer.com/#{n}" }
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
      event.primary_suggestions << build(:primary_suggestion, event: event)
    end

    after :stub do |event|
      event.send(:generate_uuid)
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

  factory :primary_suggestion, aliases: [:suggestion] do
    description 'A pretty good suggestion.'
    event
  end

  factory :secondary_suggestion do
    description 'A pretty good secondary.'
    primary_suggestion
  end

  factory :reminder do
    sender factory: :user
    receiver factory: :event
  end

  factory :invitation do
    event
    invitation_text 'Some text'
    association :invitee, factory: :user
    association :sender, factory: :user

    factory :invitation_with_user do
      association :invitee, factory: :user
    end

    factory :invitation_with_group do
      association :invitee, factory: :group
    end

    factory :invitation_with_guest do
      association :invitee, factory: :guest
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
    event
    association :suggestion
    association :voter, factory: :user

    factory :guest_vote do
      association :voter, factory: :guest
    end

    after :build do |vote, attributes|
      if Invitation.
        where(invitee_id: attributes.voter_id).
        where(event_id: vote.event.id).
        empty?
        create(
          :invitation,
          invitee: attributes.voter,
          event: vote.event
        )
      end
    end
  end
end
