class Group < ActiveRecord::Base
  attr_accessible :name, :yammer_group_id

  has_many :invitations, as: :invitee

  validates :yammer_group_id, :name, presence: true

  def invite(invitation)
    GroupPrivateMessenger.new(invitation).invite
  end

  def remind(invitation, sender)
    GroupPrivateMessenger.new(invitation, sender).remind
  end

  def voted_for_event?(_)
    false
  end

  def yammer_user?
   false
  end

  def yammer_user_id
    nil
  end
end
