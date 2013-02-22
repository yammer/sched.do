class UserMailer < ActionMailer::Base
  add_template_helper(EventHelper)
  include ActionView::Helpers::TextHelper

  NO_REPLY_FROM_EMAIL = '<no-reply@sched.do>'
  default from: %("sched.do" #{NO_REPLY_FROM_EMAIL})
  helper :mail

  def event_created_confirmation(event)
    @event = event
    @creator = @event.owner

    mail(
      to: @creator.email,
      subject: "You created #{@event.name} on sched.do"
    )
  end

  def invitation(invitation)
    @guest = invitation.invitee
    @sender = invitation.sender
    @event = invitation.event
    @invitation = invitation

    mail(
      to: @guest.email,
      subject: "Help out #{@event.owner}"
    )
  end

  def reminder(invitation, sender)
    @guest = invitation.invitee
    @sender = sender
    @event = invitation.event

    mail(
      to: @guest.email,
      subject:
        "Reminder: Help out #{@sender.name} by voting on #{@event.name}"
    )
  end

  def vote_confirmation(vote)
    @user = vote.voter
    @event = vote.event

    mail(
      to: @user.email,
      subject: %{Thanks for voting on "#{truncate(@event.name, length: 23)}" on sched.do}
    )
  end

  def vote_notification(vote)
    @voter = vote.voter
    @event = vote.event

    mail(
      to: @event.owner.email,
      subject: %{#{@voter.name} voted on "#{truncate(@event.name, length: 23)}" on sched.do}
    )
  end
end
