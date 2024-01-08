class User < ApplicationRecord
  # Existing validations and methods...

  def confirm_email(email_confirmation_token)
    raise ArgumentError, 'Token cannot be blank' if email_confirmation_token.blank?

    token_record = EmailConfirmationToken.find_by(token: email_confirmation_token)
    if token_record.nil? || token_record.used? || token_record.expires_at < Time.now.utc
      return { error: 'Invalid or expired token' }
    end

    token_record.update!(used: true, updated_at: Time.now.utc)

    user = User.find_by(id: token_record.user_id)
    if user.nil?
      return { error: 'User not found' }
    end

    user.update!(email_confirmed: true, updated_at: Time.now.utc)
    { success: 'Email has been confirmed successfully' }
  end

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
