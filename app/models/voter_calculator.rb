class VoterCalculator
  def initialize(suggestion)
    @suggestion = suggestion
    @event = suggestion.event
  end

  def voters
    @voters ||= @suggestion.votes.map(&:voter)
  end

  def non_voters
    @non_voters ||= @event.users + @event.guests - voters
  end
end
