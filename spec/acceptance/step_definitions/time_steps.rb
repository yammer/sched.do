step ':email_address does not act on the invitation for :number_of_days days' do |email_address, number_of_days|
  Timecop.travel(number_of_days.to_i.days.from_now)
  Scheduler.daily
end
