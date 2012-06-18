class GuestVote < ActiveRecord::Base
  attr_accessible :name, :email

  has_one :vote, as: :votable

  validates :name, presence: true
  validates :email, presence: true
end
