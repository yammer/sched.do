class UserVote < ActiveRecord::Base
  belongs_to :user

  has_one :vote, as: :votable

  validates :user_id, presence: true
end
