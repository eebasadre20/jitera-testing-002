class EmailConfirmationToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true

  def confirm_email
    return { error: 'Token is empty' } if token.blank?

    email_confirmation_token = EmailConfirmationToken.find_by(token: token)
    if email_confirmation_token.nil? || email_confirmation_token.used? || email_confirmation_token.expires_at < Time.current
      return { error: 'Invalid or expired token' }
    end

    EmailConfirmationToken.transaction do
      email_confirmation_token.update!(used: true, updated_at: Time.current)
      user = email_confirmation_token.user
      user.update!(email_confirmed: true, updated_at: Time.current)
    end

    { success: 'Email has been confirmed successfully' }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end

  private

  def token_blank?
    token.blank?
  end

  def token_used?
    used
  end
end
