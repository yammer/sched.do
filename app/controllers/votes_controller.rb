class VotesController < ApplicationController
  skip_before_filter :require_yammer_login
  before_filter :require_guest_or_yammer_login

  def create
    vote = Vote.new(params[:vote])
    vote.voter = current_user

    if !vote.save
      flash[:error] = "Sorry, you cannot duplicate votes"
    end

    respond_to do |format|
      format.html { redirect_to vote.event }
      format.json { render json: { vote: vote } }
    end
  end

  def destroy
    suggestion = Suggestion.find(params[:vote][:suggestion_id])
    vote = current_user.vote_for_suggestion(suggestion)
    vote.destroy

    respond_to do |format|
      format.html { redirect_to suggestion.event }
      format.json { render json: { status: :ok }  }
    end
  end
end
