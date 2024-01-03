
class ConfirmEmailService
  def initialize(token)
    @token = token
  end

  def call
    email_confirmation = EmailConfirmation.find_by(token: @token)

    if email_confirmation.nil?
      return { error: 'Token is invalid' }
    elsif email_confirmation.expires_at < Time.current
      return { error: 'Token is invalid or expired' }
    end

    user = User.find_by(id: email_confirmation.user_id)
    return { error: 'User not found' } if user.nil?

    EmailConfirmation.transaction do
      email_confirmation.update!(confirmed: true, updated_at: Time.current)
      user.update!(email_verified: true, updated_at: Time.current)
    end

    { success: 'Email has been successfully confirmed.' }
  rescue ActiveRecord::RecordNotFound
    { error: 'User not found' }
  rescue StandardError => e
    { error: e.message }
  end
end
