require 'spec_helper'

describe Vote do
  it { should belong_to(:suggestion) }
end

describe Vote, '#event' do
  it "returns the vote's event" do
    vote = create(:vote)
    vote.event.should == vote.suggestion.event
  end
end
