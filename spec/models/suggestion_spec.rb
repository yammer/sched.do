require 'spec_helper'

describe Suggestion do
  it { should validate_presence_of(:description) }

  it { should belong_to :event }

  it { should allow_mass_assignment_of(:description) }
end
