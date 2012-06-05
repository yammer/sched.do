class VotesController < ApplicationController
  def create
    vote = current_user.votes.create(params[:vote])
    redirect_to vote.event
  end
end
