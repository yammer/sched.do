class VotesController < ApplicationController
  skip_before_filter :require_yammer_login
  before_filter :require_guest_or_yammer_login

  def create
    vote = Vote.new(vote_params)
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
    vote = current_user.votes.find(params[:vote][:id])
    vote.destroy

    respond_to do |format|
      format.html { redirect_to vote.event }
      format.json { render json: { status: :ok }  }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(
      :event_id,
      :suggestion_id,
      :suggestion_type
    )
  end
end
