require 'spec_helper'

describe Suggestion do
  it { should validate_presence_of(:time) }

  it { should belong_to :event }

  it { should allow_mass_assignment_of(:time) }

  it 'rejects a time in the past' do
    should_not allow_value(1.day.ago).for(:time).with_message("must be in the future")
  end

  it 'allows a time in the future' do
    should allow_value(1.hour.from_now).for(:time)
  end
end
