class ConfirmEmailService
  def initialize(token)
    @token = token
  end

  def call
    email_confirmation = EmailConfirmation.find_by(token: @token, confirmed: false)

    if email_confirmation.nil? || email_confirmation.expires_at < Time.current
      return { error: 'Token is invalid or expired' }
    end

    EmailConfirmation.transaction do
      email_confirmation.update!(confirmed: true)
      user = User.find(email_confirmation.user_id)
      user.update!(email_verified: true)
    end

    { success: 'Email has been successfully confirmed.' }
  rescue ActiveRecord::RecordNotFound
    { error: 'User not found' }
  rescue StandardError => e
    { error: e.message }
  end
end
