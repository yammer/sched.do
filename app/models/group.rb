class Group < ActiveRecord::Base
  attr_accessible :name, :yammer_group_id

  has_many :invitations, as: :invitee

  validates :yammer_group_id, :name, presence: true

  def deliver_email_or_private_message(message, sender, object)
     PrivateMessenger.new(self, "group_#{message}", object).deliver
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
