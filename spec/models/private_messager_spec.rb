require 'spec_helper'

describe PrivateMessager do
  it 'posts to a Yammer Private Message when created' do
   invitation = build(:invitation_with_user)

   private_message = PrivateMessager.new(invitation).deliver
   FakeYammer.messages_endpoint_hits.should == 1
  end
end
