class Calendar
  def self.generate(event)
    new(event).generate
  end

  def initialize(event)
    @organizer_name = event.owner_name
    @organizer_email = event.owner_email
    @summary = event.name
    @start = to_ics_date(event.winning_suggestion.try(:full_description))
  end

  def generate
    ERB.new(File.read('app/views/calendars/ics.erb')).result(binding)
  end

  private

  def to_ics_date(text)
    DateTime.parse(text).strftime('%Y%m%dT%H%M%S')
  end
end
