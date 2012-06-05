require 'spec_helper'

describe Vote do
  it { should belong_to(:suggestion) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:suggestion_id) }

  context 'uniqueness' do
    before do
      create(:vote)
    end

    it { should validate_uniqueness_of(:suggestion_id).scoped_to(:user_id) }
  end
end

describe Vote, '#event' do
  it "returns the vote's event" do
    vote = create(:vote)
    vote.event.should == vote.suggestion.event
  end
end
