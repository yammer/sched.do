require 'spec_helper'

describe Event do
  it { should have_many(:suggestions) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }

  it { should allow_mass_assignment_of(:suggestion) }
  it { should allow_mass_assignment_of(:suggestions_attributes) }

  it { should accept_nested_attributes_for(:suggestions).allow_destroy(true) }

  it 'rejects blank suggestions' do
    nested_attributes_options = Event.nested_attributes_options[:suggestions]
    nested_attributes_options[:reject_if].call({ description: '' }).should be_true
  end
end
