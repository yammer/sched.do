class YammerInvitee < ActiveRecord::Base
  attr_accessible :yammer_user_id, :name

  has_many :invitations, as: :invitee

  validates :yammer_user_id, presence: true
  validates :name, presence: true
end
