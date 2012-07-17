class GuestVote < ActiveRecord::Base
  belongs_to :guest

  has_one :vote, as: :votable

  validates :guest_id, presence: true

  after_create :send_confirmation_email

  private

  def send_confirmation_email
    GuestMailer.vote_confirmation(self).deliver
  end
end
