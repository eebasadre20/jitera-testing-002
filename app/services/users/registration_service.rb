
# FILE PATH: /app/services/users/registration_service.rb
require 'bcrypt'
require '/app/models/email_confirmation.rb'
require '/app/models/user.rb'
require '/app/mailers/user_mailer.rb' # Ensure the UserMailer is required

module Users
  class RegistrationService < BaseService
    include ActiveModel::Validations

    attr_accessor :email, :password, :password_confirmation

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 10 }, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{10,}\z/, message: "Password must be at least 10 characters long and include alphanumeric characters." }
    validates :password_confirmation, presence: true

    validate :password_match
    validate :email_unique?

    def initialize(email, password, password_confirmation)
      @email = email
      @password = password
      @password_confirmation = password_confirmation
    end

    def register
      return { success: false, message: errors.full_messages.join(', ') } unless valid?

      password_salt = BCrypt::Engine.generate_salt
      password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      user = User.new(email: email, password_hash: password_hash, password_salt: password_salt, email_verified: false)
      email_confirmation = EmailConfirmation.new

      if user.save
        token = generate_confirmation_token(user)
        send_confirmation_email(user, token)
        { success: true, user_id: user.id, email: user.email, email_verified: user.email_verified }
      else
        { success: false, message: user.errors.full_messages.join(', ') }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end

    private

    def generate_confirmation_token(user)
      raw, enc = Devise.token_generator.generate(EmailConfirmation, :token)
      user.email_confirmations.create(token: enc, created_at: Time.now.utc, expires_at: 15.days.from_now, confirmed: false)
      raw
    end

    def password_match
      errors.add(:password_confirmation, I18n.t('activerecord.errors.messages.confirmation')) if password != password_confirmation
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
