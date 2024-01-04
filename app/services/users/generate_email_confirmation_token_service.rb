require 'securerandom'

module Users
  class GenerateEmailConfirmationTokenService
    def initialize(user_id)
      @user_id = user_id
    end

    def call
      token = SecureRandom.hex(10)
      expires_at = 12.hours.from_now

      email_confirmation_token = EmailConfirmationToken.new(
        token: token,
        expires_at: expires_at,
        user_id: @user_id
      )

      email_confirmation_token.save!
      { token: token, expires_at: expires_at }
    rescue => e
      { error: e.message }
    end
  end
end
