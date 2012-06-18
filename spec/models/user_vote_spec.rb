require 'spec_helper'

describe UserVote do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user_id) }
  it { should have_one(:vote) }
end
