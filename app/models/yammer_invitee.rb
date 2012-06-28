class YammerInvitee < ActiveRecord::Base
  attr_accessible :yammer_user_id, :name

  has_many :invitations, as: :invitee

  validates :yammer_user_id, presence: true
  validates :name, presence: true

  def self.invite(event, params)
    yammer_invitee = YammerInvitee.find_or_create_by_yammer_user_id(yammer_user_id: params[:yammer_user_id], name: params[:name])
    Invitation.find_or_create_by_event_and_invitee(event, yammer_invitee)
  end
end
