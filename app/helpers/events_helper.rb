module EventsHelper
  def event_invitee_username(event, invitee, &block)
    content = image_tag('/assets/bullhorn.svg') + capture(&block)

    if event.user_owner?(invitee)
      content_tag(:td, content, :class => 'event-creator')
    else
      content_tag(:td) do
        block.call
      end
    end
  end
end
