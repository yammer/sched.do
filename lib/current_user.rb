class CurrentUser
  def initialize(token, name, email)
    @token = token
    @name = name
    @email = email
  end

  def find
    user || guest || null_user
  end

  def self.find(token, name, email)
    new(token, name, email).find
  end

  private

  def user
    User.find_by_encrypted_access_token(@token)
  end

  def guest
    if @name && @email
      Guest.find_or_create_by_email(@email).tap do |guest|
        guest.update_attributes(name: @name)
      end
    end
  end

  def null_user
    NullUser.new
  end
end
