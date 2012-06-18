require 'spec_helper'

describe Vote do
  it { should belong_to(:suggestion) }
  it { should validate_presence_of(:suggestion_id) }
  it { should belong_to(:votable).dependent(:destroy) }
  it { should validate_presence_of(:votable_id) }
end

describe Vote, '#event' do
  it "returns the vote's event" do
    vote = create(:vote)
    vote.event.should == vote.suggestion.event
  end
end
