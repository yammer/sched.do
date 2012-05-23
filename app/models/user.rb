class User < ActiveRecord::Base
  attr_accessible :access_token, :encrypted_access_token, :name

  validates :access_token, presence: true
  validates :encrypted_access_token, presence: true
  validates :name, presence: true
  validates :salt, presence: true
  validates :yammer_user_id, presence: true

  before_validation(on: :create) do
    set_salt_if_necessary
    set_encrypted_access_token
  end

  private

  def set_salt_if_necessary
    if salt.blank?
      self.salt = SaltGenerator.new.generate
    end
  end

  def set_encrypted_access_token
    self.encrypted_access_token = Encrypter.new(access_token, salt).encrypt
  end
end
