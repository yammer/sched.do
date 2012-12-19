module EmailSpec
  def last_email_sent
    if email = Email.last
      Mail.read(email.mail)
    else
      raise("No email has been sent!")
    end
  end

  def last_email_sent_to(email)
    ActionMailer::Base.
      deliveries.
      select { |delivery| delivery.to.include?(email) }.
      last
  end

  def email_body(email)
    email.default_part_body.to_s
  end
end

RSpec.configure do |c|
  c.include EmailSpec
end
