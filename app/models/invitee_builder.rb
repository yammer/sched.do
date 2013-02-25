class InviteeBuilder
  def initialize(email, event)
    @email = email
    @event = event
  end

  def find_user_by_email_or_create_guest
    get_scheddo_user ||
      get_user_from_yammer ||
      create_guest
  end

  private

  def get_scheddo_user
    User.find_by_email(@email) ||
    Guest.find_by_email(@email)
  end

  def get_user_from_yammer
    yammer_user = get_yammer_user_by_email

    if yammer_user.present?
      User.new.tap do |user|
        YammerUserResponseTranslator.
          new(yammer_user, user).
          translate.
          save!
      end
    end
  end

  def get_yammer_user_by_email
    @event.owner.
      yammer_client.
      get('/users/by_email', email: @email).
      try(:first)
  end

  def create_guest
    Guest.create(email: @email)
  end
end
