module EmailSpec
  def last_email_sent
    if email = Email.last
      Mail.read(email.mail)
    else
      raise("No email has been sent!")
    end
  end

  def email_body(email)
    email.default_part_body.to_s
  end
end

RSpec.configure do |c|
  c.include EmailSpec
end
