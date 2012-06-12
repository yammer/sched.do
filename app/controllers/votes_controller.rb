class VotesController < ApplicationController
  def create
    vote = current_user.votes.create(params[:vote])
    redirect_to vote.event
  end

  def destroy
    suggestion = Suggestion.find(params[:vote][:suggestion_id])
    vote = current_user.vote_for_suggestion(suggestion)
    vote.destroy
    redirect_to suggestion.event
  end
end
