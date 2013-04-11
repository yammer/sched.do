class UserMailer < ActionMailer::Base
  add_template_helper(EventHelper)
  include ActionView::Helpers::TextHelper

  NO_REPLY_FROM_EMAIL = '<no-reply@sched.do>'
  default from: %("sched.do" #{NO_REPLY_FROM_EMAIL})
  helper :mail

  def event_created_confirmation(event)
    @event = event
    @creator = @event.owner

    mail(to: @creator.email, subject: "You created #{@event.name} on sched.do")
  end

  def invitation(invitation)
    @recipient = invitation.invitee
    @sender = invitation.sender
    @event = invitation.event
    @custom_text = invitation.invitation_text

    mail(to: @recipient.email, subject: "Help out #{@event.owner}")
  end

  def reminder(recipient, sender, event)
    @recipient = recipient
    @sender = sender
    @event = event

    mail(
      to: @recipient.email,
      subject: "Reminder: #{@sender.name} wants you to vote on #{@event.name}"
    )
  end

  def winner_notification(recipient, event, custom_text)
    @recipient = recipient
    @sender = event.owner
    @event = event
    @custom_text = custom_text
    winning_suggestion = @event.winning_suggestion.full_description

    mail(
      to: @recipient.email,
      subject: "#{@event.owner} has chosen #{winning_suggestion} for #{@event.name}"
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
