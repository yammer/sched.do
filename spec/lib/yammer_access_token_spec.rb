require 'spec_helper'

describe YammerAccessToken, '#parse_out_token' do
  let(:real_token) { 'abc123' }
  let(:token_string) do
    %Q({"created_at"=>"2012/05/22 12:50:00 +0000", "network_name"=>"Yammer", "view_groups"=>true, "view_messages"=>true, "expires_at"=>nil, "token"=>"#{real_token}", "user_id"=>5556661234, "view_tags"=>true, "view_subscriptions"=>true, "network_permalink"=>"yammer.com", "modify_subscriptions"=>true, "authorized_at"=>"2012/05/22 12:50:00 +0000", "view_members"=>true, "modify_messages"=>true, "network_id"=>12345})
  end

  it 'returns the correct token' do
    YammerAccessToken.new(token_string).real_token.should == real_token
  end
end
