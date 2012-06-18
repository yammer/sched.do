class VotesController < ApplicationController
  skip_before_filter :require_yammer_login
  before_filter :require_guest_or_yammer_login

  def create
    vote = Vote.new(params[:vote])
    user_vote = current_user.build_user_vote
    user_vote.vote = vote
    user_vote.save
    redirect_to vote.event
  end

  def destroy
    suggestion = Suggestion.find(params[:vote][:suggestion_id])
    vote = current_user.vote_for_suggestion(suggestion)
    vote.destroy
    redirect_to suggestion.event
  end
end
