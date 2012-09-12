class UserMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper
  default from: %{"Sched.do" <no-reply@sched.do>}

  def event_created_confirmation(event)
    @event = event
    @creator = @event.user
    mail(to: @creator.email,
      from: %{'Sched.do' <no-reply@sched.do>},
      subject: "You created #{@event.name} on Sched.do")
  end

  def invitation(guest, event)
    @guest = guest
    @event = EventDecorator.decorate(event)
    mail(to: @guest.email,
      from: %{"#{@event.user.name} via Sched.do" <no-reply@sched.do>},
      subject: "You have been invited to a Sched.do event!")
  end

  def vote_confirmation(vote)
    @user = vote.voter
    @event = vote.suggestion.event
    mail(to: @user.email,
      subject: %{Thanks for voting on "#{truncate(@event.name, length: 23)}" on Sched.do})
  end
end
