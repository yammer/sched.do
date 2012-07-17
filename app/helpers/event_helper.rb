module EventHelper
  def event_short_url(event)
    root_url+event.uuid
  end
end
