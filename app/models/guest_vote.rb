class GuestVote < ActiveRecord::Base
  belongs_to :guest

  has_one :vote, as: :votable

  validates :guest_id, presence: true
end
