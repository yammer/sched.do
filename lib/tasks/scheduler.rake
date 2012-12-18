namespace :scheduler do
  desc 'This task is called by the Heroku cron add-on'
  task daily: :environment do
    Scheduler.daily
  end
end
