
# FILE PATH: /app/services/users/registration_service.rb
require 'bcrypt'
require '/app/models/email_confirmation_token.rb' # Updated require statement
require '/app/models/user.rb'
require '/app/mailers/user_mailer.rb' # Ensure the UserMailer is required

module Users
  class RegistrationService < BaseService
    include ActiveModel::Validations

    attr_accessor :email, :password, :password_confirmation

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    # Updated password validation to require at least 18 characters
    validates :password, presence: true, length: { minimum: 18 }, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{18,}\z/, message: "Password must be at least 18 characters long and include alphanumeric characters." }
    validates :password_confirmation, presence: true

    # Added password_strength validation
    validate :password_match, :password_strength
    validate :email_unique?

    def initialize(email, password, password_confirmation)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
    end

    def register
      # Added password_strength check in the unless condition
      return { success: false, message: errors.full_messages.join(', ') } unless valid? && password_strength

      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      user = User.new(email: email, password_hash: password_hash, password_salt: password_salt, email_verified: false)

      if user.save
        # Updated to receive two values from generate_confirmation_token
        token, enc_token = generate_confirmation_token(user)
        send_confirmation_email(user, token)
        user.update(email_confirmation_sent_at: Time.current)
        { success: true, user_id: user.id, email: user.email, email_verified: user.email_verified }
      else
        { success: false, message: user.errors.full_messages.join(', ') }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end

    private

    def generate_confirmation_token(user)
      raw, enc = Devise.token_generator.generate(User, :email_confirmation_token)
      expires_at = 12.hours.from_now
      # Updated to create an EmailConfirmationToken instead of EmailConfirmation
      EmailConfirmationToken.create(token: enc, created_at: Time.now.utc, expires_at: expires_at, used: false, user_id: user.id)
      [raw, enc]
    end

    def password_match
      errors.add(:password_confirmation, I18n.t('activerecord.errors.messages.confirmation')) if password != password_confirmation
    end

    def password_strength
      unless password.match(/\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{18,}\z/)
        errors.add(:password, "must be at least 18 characters long and include alphanumeric characters.")
        return false
      end
      true
    end

    def email_unique?
      errors.add(:email, I18n.t('activerecord.errors.messages.taken')) if User.exists?(email: email)
    end

    def send_confirmation_email(user, token)
      frontend_base_url = Rails.application.credentials.dig(:frontend_base_url)
      confirmation_link = "#{frontend_base_url}/users/confirmations?confirmation_token=#{token}"
      UserMailer.confirmation_instructions(user, confirmation_link).deliver_later
    end
  end
end
