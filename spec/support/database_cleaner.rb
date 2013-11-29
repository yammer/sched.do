RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(type: :request) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    Dotenv.load
  end

  config.after(type: :request) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
    FakeYammer.reset
  end

  config.after(:each, javascript: true) do
    page.execute_script('localStorage.clear();')
  end

  config.after(:each) do
    Timecop.return
    DatabaseCleaner.clean
  end
end
