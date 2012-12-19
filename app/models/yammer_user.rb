class YammerUser
  def initialize(auth)
    @access_token = auth[:access_token]
    @yammer_staging = auth[:yammer_staging]
    @yammer_user_id = auth[:yammer_user_id]
  end

  def find_or_create
    find_or_create_user
    set_user_access_token
    associate_guest_invitations
    @user
  end

  private

  def find_or_create_user
    find_user || create_user_with_auth
  end

  def find_user
    @user ||= User.find_by_yammer_user_id(@yammer_user_id)
  end

  def create_user_with_auth
    @user = User.new(auth)
    @user.fetch_yammer_user_data
  end

  def auth
    {
      yammer_user_id: @yammer_user_id,
      access_token: @access_token,
      yammer_staging: @yammer_staging
    }
  end

  def set_user_access_token
    @user.access_token = @access_token
  end

  def associate_guest_invitations
    @user.associate_guest_invitations
  end
end
