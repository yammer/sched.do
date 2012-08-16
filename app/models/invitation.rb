class Invitation < ActiveRecord::Base
  attr_accessor :skip_notification, :invitee_params
  attr_accessible :event, :invitee, 
    :invitee_attributes, :event_id, :skip_notification

  belongs_to :event
  belongs_to :invitee, polymorphic: true

  accepts_nested_attributes_for :invitee

  validates :event_id, presence: true
  validates :invitee_type, presence: true
  validate  :invitee_is_not_event_owner
  validates :invitee_id, presence: { message: "is invalid" }
  validates :invitee_id, uniqueness: {
    message: "has already been invited",
    scope: [:invitee_type, :event_id]
  }

  after_create :send_notification, unless: :skip_notification

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

  def invitee_is_not_event_owner
    errors[:base] << "You can not invite yourself" if invitee == event.try(:user)
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

  def find_group
    Group.find_or_create_by_yammer_group_id(
      yammer_group_id: invitee_params[:yammer_group_id], 
      name: invitee_params[:name_or_email])
  end

  def find_guest
    Guest.find_by_email(invitee_params[:name_or_email]) || 
      Guest.create_without_name_validation(invitee_params[:name_or_email])
  end

  def find_or_create_invitee
    if invitee_params[:yammer_user_id].present?
      find_user
    elsif invitee_params[:yammer_group_id].present?
      find_group
    else
      find_guest
    end
  end

  def find_user
    User.find_or_create_with_auth(
        access_token: event.user.access_token,
        yammer_staging: event.user.yammer_staging?,
        yammer_user_id: invitee_params[:yammer_user_id]
    )
  end
end
