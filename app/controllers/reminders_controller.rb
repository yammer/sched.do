class RemindersController < ApplicationController
  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.sender = current_user

    if @reminder.save
      flash[:notice] = "Reminders sent"
    else
      flash[:error] = "There was an error sending reminders"
    end

    redirect_to event_path(params[:event_id])
  end

  private

  def reminder_params
    params.require(:reminder).permit(
      :receiver_id,
      :receiver_type
    )
  end
end
