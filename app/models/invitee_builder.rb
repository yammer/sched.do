class InviteeBuilder
  def initialize(email, event)
    @email = email
    @event = event
  end

  def find_user_by_email_or_create_guest
    existing_scheddo_user ||
      find_existing_yammer_user ||
      create_guest
  end

  private

  def existing_scheddo_user
    User.find_by_email(@email) ||
    Guest.find_by_email(@email)
  end

  def find_existing_yammer_user
    user_id = find_user_id_by_email

    if user_id.present?
      YammerUser.new(
        access_token: @event.owner.access_token,
        yammer_staging: @event.owner.yammer_staging?,
        yammer_user_id: user_id
      ).find_or_create
    end
  end

  def find_user_id_by_email
    @event.owner.yammer_client.get('/users/by_email', email: @email).try(:first).try(:id)
  end

  def create_guest
    Guest.create_without_name_validation(@email)
  end
end
