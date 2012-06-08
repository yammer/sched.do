if Rails.env.development?
  # Sync stdout so that output from foreman shows up.
  $stdout.sync = true
end
