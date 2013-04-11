class WinningSuggestionsController < ApplicationController
  def create
    @event = current_user.events.opened.find(params[:event_id])
    event_params = params.slice(
      :winning_suggestion_id,
      :winning_suggestion_type,
      :message
    )

    EventCloser.new(@event, event_params).process

    redirect_to @event
  end
end
