require 'spec_helper'

describe Event do
  it { should validate_presence_of(:name) }
  it { should have_many(:suggestions) }

  it { should allow_mass_assignment_of(:suggestion) }
  it { should allow_mass_assignment_of(:suggestions_attributes) }

  it { should accept_nested_attributes_for(:suggestions) }
end
