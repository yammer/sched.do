class VotesController < ApplicationController
  def create
    vote = current_user.votes.create(params[:vote])
    redirect_to vote.event
  end

  def destroy
    vote = current_user.vote_for_suggestion(params[:vote][:suggestion_id])
    event = vote.event
    vote.destroy
    redirect_to event
  end
end
