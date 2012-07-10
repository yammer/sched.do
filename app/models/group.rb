class Group < ActiveRecord::Base
  attr_accessible :name, :yammer_group_id

  has_many :invitations, as: :invitee

  validates :yammer_group_id, :name, presence: true

  def notify(invitation)

  end
end
