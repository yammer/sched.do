require 'spec_helper'

describe GuestVote do
  it { should have_one(:vote) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
end
