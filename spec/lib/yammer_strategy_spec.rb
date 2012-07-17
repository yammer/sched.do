require 'spec_helper'

describe OmniAuth::Strategies::Yammer do
  include Rack::Test::Methods

  subject { OmniAuth::Strategies::Yammer.new(app) }

  it 'is named "yammer"' do
    subject.name.should == 'yammer'
  end

  it 'has correct URLs' do
    subject.options.client_options.site.should == 'https://www.yammer.com'
    subject.client.options[:authorize_url].should == '/dialog/oauth'
    subject.client.options[:token_url].should == '/oauth2/access_token.json'
  end

  it 'sets the correct info' do
    subject.stubs(raw_info: yammer_raw_info)
    subject.stubs(access_token: stub(token: 'abc123'))

    subject.info[:access_token].should == 'abc123'
    subject.info[:email].should == 'henry@example.com'
    subject.info[:image].should == 'https://www.yammer.com/mugshot/48x48/12345678'
    subject.info[:name].should == 'Henry Smith'
    subject.info[:nickname].should == 'henry'
    subject.info[:yammer_profile_url].should == 'https://www.yammer.com/example.com/users/henry'
    subject.extra.should_not be_nil
  end

  def app
    Rack::Builder.new do |builder|
      builder.use Rack::Session::Cookie
      builder.use OmniAuth::Strategies::Yammer
      builder.run lambda { |env| [200, {}, ['Not Found']] }
    end.to_app
  end

  def yammer_raw_info
    {"interests"=>"",
     "location"=>"",
     "significant_other"=>"",
     "birth_date"=>"",
     "external_urls"=>[],
     "network_domains"=>["example.com"],
     "kids_names"=>"",
     "url"=>"https://www.yammer.com/api/v1/users/1112223333",
     "guid"=>nil,
     "schools"=>[],
     "contact"=>{"im"=>{"provider"=>"aim", "username"=>""},
                 "email_addresses"=>[{"address"=>"henry@example.com",
                                      "type"=>"primary"}],
                 "phone_numbers"=>[{"type"=>"work", "number"=>"5551234567"}]},
     "id"=>1112223333,
     "full_name"=>"Henry Smith",
     "expertise"=>"",
     "previous_companies"=>[],
     "timezone"=>"Eastern Time (US & Canada)",
     "type"=>"user",
     "can_broadcast"=>"false",
     "stats"=>{"followers"=>5, "updates"=>13, "following"=>11},
     "department"=>nil,
     "job_title"=>"Developer",
     "verified_admin"=>"false",
     "network_id"=>63286,
     "admin"=>"false",
     "state"=>"active",
     "hire_date"=>nil,
     "mugshot_url_template"=>"https://www.yammer.com/mugshot/{width}x{height}/12345678",
     "settings"=>{"xdr_proxy"=>"https://xdrproxy.yammer.com"},
     "activated_at"=>"2012/05/21 13:30:44 +0000",
     "mugshot_url"=>"https://www.yammer.com/mugshot/48x48/12345678",
     "web_url"=>"https://www.yammer.com/example.com/users/henry",
     "name"=>"henry",
     "summary"=>"",
     "network_name"=>"Example"}
  end
end
