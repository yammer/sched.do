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

  def message
    "#{event.user.name} has invited you to the event #{event.name} on Sched.do!"
  end

  def name_or_email
    invitee.try(:name) || invitee.try(:email)
  end

  def yammer_user_id
    invitee.try(:yammer_user_id)
  end

  def yammer_group_id
    invitee.try(:yammer_group_id)
  end

  def send_notification
    invitee.notify(self)
  end
end
