require 'spec_helper'

describe YammerUserResponseTranslator do
  describe '.translate' do
    it 'translates a yammer response to a scheddo User' do
      response = { id: 1,
        mugshot_url: 'http://image',
        full_name: 'John Doe',
        name: 'John',
        web_url: 'http://web_url',
        network_id: 2,
        network_name: 'network',
        'contact' => {
          'email_addresses' => [{
            'type' => 'primary',
            'address' => 'a@b.com'
          }]
        }
      }
      user = User.new

      YammerUserResponseTranslator.new(response, user).translate

      expect(user.yammer_user_id).to eq 1
      expect(user.email).to eq 'a@b.com'
      expect(user.image).to eq 'http://image'
      expect(user.name).to eq 'John Doe'
      expect(user.nickname).to eq 'John'
      expect(user.yammer_profile_url).to eq 'http://web_url'
      expect(user.yammer_network_id).to eq 2
      expect(user.yammer_network_name).to eq 'network'
      expect(user.extra).to eq response
    end
  end
end
