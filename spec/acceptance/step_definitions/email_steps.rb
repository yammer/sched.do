step ':email_address should receive an email' do |email_address|
  expect(unread_emails_for(email_address).size).to eq 1
end

step ':email_address should receive an email with the text :email_text' do |email_address, email_text|
  expect(unread_emails_for(email_address).size).to eq 1
  expect(email_body(last_email_sent)).to match /#{Regexp.escape(email_text)}/
end

step ':email_address follows the link :link in his email' do |email_address, link|
  open_email(email_address)
  visit_in_email(link)
end

step ':email_address should receive a vote confirmation email with a link to :event_name' do |email_address, event_name|
  event = Event.find_by_name(event_name)
  guest = event.invitees.first
  body = email_body(last_email_sent_to(guest.email))
  expect(body).to have_link('Click Here')
  expect(body).to include(event_url(event))
  expect(body).to include('Thanks for voting!')
end

step 'I should receive a vote notification email with a link to :event_name' do |event_name|
  event = Event.find_by_name(event_name)
  body = email_body(last_email_sent_to(event.owner.email))
  expect(body).to have_link('Click Here')
  expect(body).to include(event_url(event))
  expect(body).to include('voted on your')
end

step ':email_address should receive a reminder email with a link to :event_name' do |email_address, event_name|
  event = Event.find_by_name(event_name)
  guest = event.invitees.first
  body = email_body(last_email_sent_to(guest.email))
  expect(body).to have_link('Click Here')
  expect(body).to include(event_url(event))
  expect(body).to include('Reminder to vote')
end

step ':email_address should receive an invitation email with a link to :event_name' do |email_address, event_name|
  event = Event.find_by_name(event_name)
  guest = event.invitees.first
  body = email_body(last_email_sent_to(guest.email))
  expect(body).to have_link('Click Here')
  expect(body).to include(event_url(event))
  expect(body).to include('invited')
end

step ':email_address should have :count email(s)' do |email_address, count|
  expect(mailbox_for(email_address).size).to eq count.to_i
end

step 'out-network Yammer user :name should get an email notification' do |name|
  user = User.find_by_name!(name)
  expect(mailbox_for(user.email).size).to eq 1
end

step 'the email should contain an image of the owner of :event_name' do |event_name|
  event = Event.find_by_name(event_name)
  guest = event.invitees.first
  body = email_body(last_email_sent_to(guest.email))
  expect(body).to include(event.owner.image)
end

step ':email_address should receive an email that contains an image of :user_name' do |email_address, user_name|
  guest = Guest.find_by_email(email_address)
  user = User.find_by_name(user_name)
  body = last_email_sent_to(guest.email)
  body = email_body(body)
  expect(body).to include(user.image)
end

step ':email_address should not receive an email' do |email_address|
  expect(unread_emails_for(email_address).size).to eq 0
end
