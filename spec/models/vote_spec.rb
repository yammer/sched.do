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

describe Vote, '#create' do
  include DelayedJobSpecHelper

  it 'sends confirmation email to user' do
    mailer = stub('mailer', deliver: true)
    UserMailer.stubs(vote_confirmation: mailer)

    vote = create(:vote)
    work_off_delayed_jobs

    UserMailer.should have_received(:vote_confirmation).with(vote)
    mailer.should have_received(:deliver).once
  end

  it 'updates Yammer activity ticker after voting' do
    FakeYammer.activity_endpoint_hits.should == 0

    vote = create(:vote)
    work_off_delayed_jobs

    FakeYammer.activity_endpoint_hits.should == 2
  end
end
