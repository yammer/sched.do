class Guest
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email

  validates :name, presence: true
  validates :email, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def guest?
    true
  end

  def yammer_user?
    false
  end

  def able_to_edit?(event)
    false
  end

  def votes
    Vote.joins("INNER JOIN guest_votes
                ON guest_votes.id = votes.votable_id
                AND votes.votable_type = 'GuestVote'").
         where('guest_votes.email = ?', @email)
  end

  def vote_for_suggestion(suggestion)
    votes.find_by_suggestion_id(suggestion.id)
  end

  def build_user_vote
    GuestVote.new(name: name, email: email)
  end
end
