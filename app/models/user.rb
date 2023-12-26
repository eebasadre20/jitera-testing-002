class User < ApplicationRecord
  # Existing validations and methods...

  # ... other model methods ...

  def generate_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end

  def send_reset_password_instructions(token)
    # Assuming Devise::Mailer is set up with a method to send reset password instructions
    Devise::Mailer.reset_password_instructions(self, token).deliver_later
  end

  # ... other model methods ...
end
