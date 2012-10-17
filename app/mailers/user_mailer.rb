class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: %{"Sched.do" <no-reply@sched.do>}

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
    @event = EventDecorator.decorate(invitation.event)
    mail(
      to: @guest.email,
      from: from_text(sender.name),
      subject: "You have been invited to a Sched.do event!"
    )
  end

  def reminder(sender, invitation)
    @guest = invitation.invitee
    @event = EventDecorator.decorate(invitation.event)
    mail(
      to: @guest.email,
      from: from_text(sender.name),
      subject: %{Reminder: Help out #{@event.owner.name} by voting on "#{@event.name}"}
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

  def from_text(user_name = nil)
    %{"#{user_name} via Sched.do" <no-reply@sched.do>}
  end
end
