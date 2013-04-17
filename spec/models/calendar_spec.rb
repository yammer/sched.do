require 'spec_helper'

describe Calendar, '.generate' do
  it 'builds an ics event' do
    event = build(:closed_event)
    start_time = DateTime.parse(event.winning_suggestion.full_description)
    expected_event = <<-TEXT.strip_heredoc
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:-//Yammer//Scheddo//EN
      BEGIN:VEVENT
      ORGANIZER;CN=#{event.owner_name}:MAILTO:#{event.owner_email}
      DTSTART:#{start_time.strftime('%Y%m%dT%H%M%S')}
      SUMMARY:#{event.name}
      END:VEVENT
      END:VCALENDAR
    TEXT

    ics_event = Calendar.generate(event)

    expect(ics_event).to eq expected_event
  end
end
