# Methods for User to interact with Yammer APIs

class YammerUser
  def initialize(auth)
    @access_token = auth[:access_token]
    @yammer_staging = auth[:yammer_staging]
    @yammer_user_id = auth[:yammer_user_id]
  end

  def find_or_create
    user = find_or_create_user

    user.tap do |user|
      user.access_token = @access_token
      user.associate_guest_invitations
      user.save!
    end
  end

  private

  def find_or_create_user
    find_user || create_user
  end

  def find_user
    User.find_by_yammer_user_id(@yammer_user_id)
  end

  def create_user
    User.create.tap do |user|
      user.yammer_user_id = @yammer_user_id
      user.access_token = @access_token
      user.yammer_staging = @yammer_staging
      user.fetch_yammer_user_data
      user.save!
    end
  end
end
