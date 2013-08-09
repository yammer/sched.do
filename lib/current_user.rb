class CurrentUser
  def initialize(yammer_user_id, name, email)
    @yammer_user_id = yammer_user_id
    @name = name
    @email = email
  end

  def find
    user || guest || null_user
  end

  def self.find(yammer_user_id, name, email)
    new(yammer_user_id, name, email).find
  end

  private

  def user
    User.find_by(yammer_user_id: @yammer_user_id)
  end

  def guest
    if @name && @email
      Guest.find_or_create_by(email: @email).tap do |guest|
        guest.update_attributes(name: @name)
      end
    end
  end

  def null_user
    NullUser.new
  end
end
