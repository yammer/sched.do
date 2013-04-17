class CalendarsController < ApplicationController
  def show
    event = Event.find_by_uuid!(params[:id])
    ics_event = Calendar.generate(event)

    send_data(ics_event, filename: 'calendar.ics')
  end
end
