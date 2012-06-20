require 'spec_helper'

describe Event do
  it { should belong_to(:user) }
  it { should have_many(:suggestions) }
  it { should have_many(:invitations) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }

  it { should allow_mass_assignment_of(:suggestion) }
  it { should allow_mass_assignment_of(:suggestions_attributes) }
  it { should allow_mass_assignment_of(:invitations_attributes) }

  it { should accept_nested_attributes_for(:suggestions).allow_destroy(true) }
  it { should accept_nested_attributes_for(:invitations) }

  it 'rejects blank suggestions' do
    nested_attributes_options = Event.nested_attributes_options[:suggestions]
    nested_attributes_options[:reject_if].call({ primary: '' }).should be_true
  end
end

describe Event, '#invitees' do
  it 'returns all users invited to the event' do
    event = create(:event)
    invitees = create_list(:invitation_with_user, 2, event: event).map(&:user)
    event.invitees.should == invitees
  end

  it 'returns an empty array if there are no invitees' do
    build(:event).invitees.should == []
  end

  it 'returns an empty array if none of the invitations have users' do
    event = create(:event)
    create_list(:invitation, 2, event: event)
    event.invitees.should == []
  end
end
