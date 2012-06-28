require 'spec_helper'

describe Event do
  it { should belong_to(:user) }
  it { should have_many(:suggestions) }
  it { should have_many(:invitations) }
  it { should have_many(:users).through(:invitations) }
  it { should have_many(:yammer_invitees).through(:invitations) }
  it { should have_many(:guests).through(:invitations) }

  it { should validate_presence_of(:name).with_message(/This field is required/) }
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
  it 'returns the event creator and users, yammer_invitees, and guests invited to the event' do
    event = create(:event)
    invitees = [event.user]
    invitees += create_list(:invitation_with_user, 2, event: event).map(&:invitee)
    invitees += create_list(:invitation_with_yammer_invitee, 2, event: event).map(&:invitee)
    invitees += create_list(:invitation_with_guest, 2, event: event).map(&:invitee)
    event.invitees.should == invitees
  end

  it 'returns just the event creator if there are no invitees' do
    event = build(:event)
    event.invitees.should == [event.user]
  end
end
