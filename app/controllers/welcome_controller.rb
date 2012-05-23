class WelcomeController < ApplicationController
  def index
    if signed_in?
      redirect_to new_event_path
    else
      render :index
    end
  end
end
