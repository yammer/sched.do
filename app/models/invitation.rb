class Invitation < ActiveRecord::Base
  attr_accessor :skip_notification, :invitee_params
  attr_accessible :event, :invitee, :invitee_attributes, :event_id,
    :skip_notification

  belongs_to :event
  belongs_to :invitee, polymorphic: true

  accepts_nested_attributes_for :invitee

  validates :event_id, presence: true
  validates :invitee_type, presence: true
  validates :invitee_id, presence: { message: "is invalid" }
  validates :invitee_id, uniqueness: {
    message: "has already been invited",
    scope: [:invitee_type, :event_id]
  }

  after_create :queue_invitation_created_job, unless: :skip_notification

  def self.invite_without_notification(event, invitee)
    create(
      event: event,
      invitee: invitee,
      skip_notification: true
    )
  end

  def build_invitee(params, options={})
    self.invitee_params = params
    self.invitee = find_or_create_invitee
  end

  def sender
    event.owner
  end

  def deliver_invitation
    invitee.deliver_email_or_private_message(:invitation, sender, self)
  end

  def deliver_reminder
    if not invitee.voted_for_event?(event)
      invitee.deliver_email_or_private_message(:reminder, sender, self)
    end
  end

  def deliver_reminders_from(_)
    deliver_reminder
  end

  private

  def access_token
    event_creator.access_token
  end

  def create_guest
    Guest.create_without_name_validation(name_or_email_param)
  end

  def event_creator
    event.owner
  end

  def existing_scheddo_user
    User.find_by_email(name_or_email_param) ||
    Guest.find_by_email(name_or_email_param)
  end

  def find_existing_yammer_user
    id_finder = YammerUserIdFinder.new(access_token, name_or_email_param)
    user_id = id_finder.find

    if user_id
      User.find_or_create_with_auth(
        access_token: access_token,
        yammer_staging: yammer_staging?,
        yammer_user_id: user_id
      )
    end
  end

  def find_group
    Group.find_or_create_by_yammer_group_id(
      yammer_group_id: yammer_group_id_param,
      name: name_or_email_param
    )
  end

  def find_or_create_invitee
    if yammer_user_id_param.present?
      find_or_create_user
    elsif yammer_group_id_param.present?
      find_group
    else
      find_user_by_email_or_create_guest
    end
  end

  def find_or_create_user
    User.find_or_create_with_auth(
        access_token: access_token,
        yammer_staging: yammer_staging?,
        yammer_user_id: yammer_user_id_param
    )
  end

  def find_user_by_email_or_create_guest
    existing_scheddo_user ||
      find_existing_yammer_user ||
      create_guest
  end

  def name_or_email_param
    invitee_params[:name_or_email]
  end

  def queue_invitation_created_job
    InvitationCreatedJob.enqueue(self)
  end

  def yammer_group_id_param
    invitee_params[:yammer_group_id]
  end

  def yammer_staging?
    event_creator.yammer_staging?
  end

  def yammer_user_id_param
    invitee_params[:yammer_user_id]
  end
end
