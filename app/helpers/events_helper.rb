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

  def display_invitee_in_grid?(event, invitee)
    current_user == invitee || 
    event.user_owner?(current_user) ||
    event.user_voted?(invitee)
  end
end
