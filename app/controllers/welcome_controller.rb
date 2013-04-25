class WelcomeController < ApplicationController
  skip_before_filter :require_yammer_login, only: [:index, :about]

  def index
    if signed_in?
      redirect_to new_event_path
    else
      render :index
    end
  end

  def about
  end
end
