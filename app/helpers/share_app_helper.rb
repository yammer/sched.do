module ShareAppHelper
  def share_app_default_text(event, user)
    if user == event.owner
      return 'I created an event in sched.do - a free tool you can use to create polls, schedule events, etc. Create your own polls at https://www.sched.do/!'
    else
      return 'I voted on an event in sched.do - a free tool you can use to create polls, schedule events, etc. Create your own polls at https://www.sched.do/!'
    end
  end
end
