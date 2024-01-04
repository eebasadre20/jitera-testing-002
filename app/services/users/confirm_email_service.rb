
class ConfirmEmailService
  def initialize(token)
    @token = token
  end

  def call
    email_confirmation = EmailConfirmationToken.find_by(token: @token, used: false)

    if email_confirmation.nil? || email_confirmation.used
      return { error: 'Token is invalid' }
    elsif email_confirmation.expires_at < Time.current
      return { error: 'Token is invalid or expired' }
    end

    user = User.find_by(id: email_confirmation.user_id)
    return { error: 'User not found' } if user.nil?

    EmailConfirmationToken.transaction do
      user.update!(email_confirmed: true, updated_at: Time.current)
      email_confirmation.update!(used: true, updated_at: Time.current)
    end

    { success: 'Email has been successfully confirmed.' }
  rescue ActiveRecord::RecordNotFound
    { error: 'User not found' }
  rescue StandardError => e
    { error: e.message }
  end
end
