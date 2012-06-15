class Guest
  def initialize(name, email)
    @name = name
    @email = email
  end

  def guest?
    true
  end

  def able_to_edit?(event)
    false
  end

  def vote_for_suggestion(suggestion)
    false
  end
end
