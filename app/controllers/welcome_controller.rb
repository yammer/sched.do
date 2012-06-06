class WelcomeController < ApplicationController
  skip_before_filter :require_login, only: :index

  def index
    if signed_in?
      redirect_to new_event_path
    else
      render :index
    end
  end
end
