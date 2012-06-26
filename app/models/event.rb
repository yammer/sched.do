class Event < ActiveRecord::Base
  attr_accessible :name, :suggestion, :suggestions_attributes, :invitations_attributes

  belongs_to :user
  has_many :suggestions
  has_many :invitations

  validates :name, presence: { message: 'This field is required' }
  validates :user_id, presence: true

  accepts_nested_attributes_for :suggestions, reject_if: :all_blank,
    allow_destroy: true
  accepts_nested_attributes_for :invitations

  def invitees
    User.find(invitations.pluck(:user_id).compact)
  end
end
