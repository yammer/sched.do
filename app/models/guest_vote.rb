class GuestVote < ActiveRecord::Base
  belongs_to :user, :foreign_key => 'guest_id', class_name: 'Guest'

  has_one :vote, as: :votable

  validates :guest_id, presence: true

end
