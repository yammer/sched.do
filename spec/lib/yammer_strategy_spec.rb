require 'spec_helper'

describe OmniAuth::Strategies::Yammer, '#primary_email' do
  context 'when no raw info is provided' do
    it 'returns nil' do
      strategy = OmniAuth::Strategies::Yammer.new({})
      strategy.stub(raw_info: {})

      email = strategy.send :primary_email

      expect(email).to be_nil
    end
  end

  context 'when a primary email is provided' do
    it 'returns the primary email address' do
      strategy = OmniAuth::Strategies::Yammer.new({})
      strategy.stub(raw_info: {
        'contact' => {
          'email_addresses' => [{
            'type' => 'primary', 'address' => 'person@example.com'
          }]
        }
      })

      email = strategy.send :primary_email

      expect(email).to eq 'person@example.com'
    end
  end

  context 'when no email is provided' do
    it 'returns nil' do
      strategy = OmniAuth::Strategies::Yammer.new({})
      strategy.stub(raw_info: { contact: { email_addresses: [] } })

      email = strategy.send :primary_email

      expect(email).to be_nil
    end
  end
end
