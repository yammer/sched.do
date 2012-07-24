class PrivateMessager < AbstractController::Base
  include AbstractController::Rendering
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers
  helper ApplicationHelper
  self.view_paths = "app/views"
  include Rails.application.routes.url_helpers
  MESSAGES_ENDPOINT = "https://www.yammer.com/api/v1/messages.json"

  def initialize(invitation)
    @template = 'invitation'
    @recipient = invitation.invitee
    @event = invitation.event
    @user = @event.user
  end

  def deliver
    body = render(@template)
    response = RestClient.post MESSAGES_ENDPOINT + "?" + {
      access_token: @user.access_token,
      body: body,
      direct_to_id: @recipient.yammer_user_id,
      og_url: event_url(@event)
    }.to_query, nil
  end
end
