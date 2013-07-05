class Group < ActiveRecord::Base
  has_many :invitations, as: :invitee

  validates :yammer_group_id, :name, presence: true

  def invite(invitation)
    messenger.invite(invitation)
  end

  def remind(event, sender)
    messenger.remind(event, sender)
  end

  def notify(event, message)
    messenger.notify(event, message)
  end

  def has_voted_for_event?(_)
    false
  end

  def yammer_user?
   false
  end

  def yammer_user_id
    nil
  end

  private

  def messenger
    @messenger ||= GroupYammerMessenger.new(self)
  end
end
