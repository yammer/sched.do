class Invitation < ActiveRecord::Base
  attr_accessible :event, :invitee

  belongs_to :event
  belongs_to :invitee, polymorphic: true

  accepts_nested_attributes_for :invitee

  validates :event_id, presence: true
  validates :invitee_id, presence: true
  validates :invitee_type, presence: true

  after_create :send_notification

  def self.find_or_create_by_event_and_invitee(event, invitee)
    find_or_create_by_event_id_and_invitee_id_and_invitee_type(event.id, invitee.id, invitee.class.name)
  end

  def self.invite(event, user)
    Invitation.find_or_create_by_event_and_invitee(event, user)
  end

  def self.invite_from_params(event, params)
    if params[:yammer_user_id].present?
      invitee = User.find_or_create_with_auth(
        {
        access_token: event.user.access_token,
        yammer_staging: event.user.yammer_staging?,
        yammer_user_id: params[:yammer_user_id]
      })
    elsif params[:yammer_group_id].present?
      invitee = find_group(params[:yammer_group_id], params[:name_or_email])
    else
      invitee = find_guest(params[:name_or_email])
    end

    Invitation.find_or_create_by_event_and_invitee(event, invitee)
  end


  def name_or_email
    invitee.try(:name) || invitee.try(:email)
  end

  def send_notification
    invitee.notify(self)
  end

  def sender
    event.user
  end
  def yammer_group_id
    invitee.try(:yammer_group_id)
  end

  def yammer_user_id
    invitee.try(:yammer_user_id)
  end

  private

  def self.find_group(yammer_group_id, name)
    Group.find_or_create_by_yammer_group_id(yammer_group_id: yammer_group_id, name: name)
  end

  def self.find_guest(email)
    Guest.find_by_email(email) || create_guest_without_validation(email)
  end

  def self.create_guest_without_validation(email)
    Guest.new.tap do |guest|
      guest.email = email
      guest.should_validate_name = false
      guest.save
    end
  end
end
