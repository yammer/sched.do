class VoterCalculator
  def initialize(suggestion)
    @suggestion = suggestion
    @event = suggestion.event
  end

  def voters
    @voters ||= suggestion_votes.map(&:voter)
  end

  def non_voters
    @non_voters ||= @event.users + @event.guests - voters
  end

  private

  def suggestion_votes
    @suggestion_votes ||=
      @suggestion.votes.select { |vote| vote.deleted_at == nil }
  end
end
