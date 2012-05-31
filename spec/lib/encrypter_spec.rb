require 'spec_helper'

describe Encrypter, '#encrypt' do
  it 'encrypts a given string' do
    string = 'string'
    salt = 'salt'
    encrypter = Encrypter.new(string, salt)
    salted_string = "--#{salt}--#{string}--"
    expected_hash = Digest::SHA1.hexdigest(salted_string)
    encrypter.encrypt.should == expected_hash
  end
end
