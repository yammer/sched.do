class YammerInvitee < ActiveRecord::Base
  attr_accessible :yammer_user_id, :name

  has_many :invitations, as: :invitee

  validates :yammer_user_id, presence: true
  validates :name, presence: true

  def self.convert_to_user_from_params(params)
    yammer_invitee = YammerInvitee.find_by_yammer_user_id(params[:uid].to_s)
    if yammer_invitee
      User.create_from_params!(params).tap do |user|
        if user
          yammer_invitee.invitations.each do |invitation|
            invitation.invitee = user
            invitation.save
          end
          yammer_invitee.destroy
        end
      end
    end
  end

  def notify(invitation)
    nil # TODO
  end

  def voted_for?(suggest)
    false
  end
end
