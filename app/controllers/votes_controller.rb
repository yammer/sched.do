class VotesController < ApplicationController
  skip_before_filter :require_yammer_login
  before_filter :require_guest_or_yammer_login

  def create
    vote = Vote.new(params[:vote])
    vote.voter = current_user

    if !vote.save
      flash[:error] = "Sorry, you cannot duplicate votes"
    end

    redirect_to vote.event
  end

  def destroy
    suggestion = Suggestion.find(params[:vote][:suggestion_id])
    vote = current_user.vote_for_suggestion(suggestion)
    vote.destroy
    redirect_to suggestion.event
  end
end
