class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  FROM_EMAIL = '<no-reply@sched.do>'
  default from: %("Sched.do" #{FROM_EMAIL})

  def event_created_confirmation(event)
    @event = event
    @creator = @event.owner

    mail(
      to: @creator.email,
      subject: "You created #{@event.name} on Sched.do"
    )
  end

  def invitation(sender, invitation)
    @guest = invitation.invitee
    @sender = sender
    @event = EventDecorator.decorate(invitation.event)

    mail(
      to: @guest.email,
      from: from_text(@sender.name),
      subject: "Help out #{@event.owner}"
    )
  end

  def reminder(sender, invitation)
    @guest = invitation.invitee
    @event = EventDecorator.decorate(invitation.event)

    mail(
      to: @guest.email,
      from: from_text(sender.name),
      subject:
        %{Reminder: Help out #{@event.owner} by voting on "#{@event.name}"}
    )
  end

  def vote_confirmation(vote)
    @user = vote.voter
    @event = vote.suggestion.event

    mail(
      to: @user.email,
      subject: %{Thanks for voting on "#{truncate(@event.name, length: 23)}" on Sched.do}
    )
  end

  private

  def from_text(user_name = nil)
    %("Sched.do on behalf of #{user_name}" #{FROM_EMAIL})
  end
end
