class UsersController < ApplicationController
  layout 'events'

  def show
    @events = current_user.events
  end
end

