class VotesController < ApplicationController
  def create
    vote = Vote.create(params[:vote])
    redirect_to vote.event
  end
end
