require 'spec_helper'

describe YammerInvitee, 'validations' do
  it { should have_many(:invitations) }

  it { should allow_mass_assignment_of(:yammer_user_id) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:yammer_user_id) }
end
