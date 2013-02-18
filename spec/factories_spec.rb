require 'spec_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    it 'is valid' do
      unless factory_name == :activity_creator
        expect(create(factory_name)).to be_valid
      end
    end
  end
end
