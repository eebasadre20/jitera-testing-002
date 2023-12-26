require 'bcrypt'
require 'doorkeeper'
require 'i18n'
require 'uri/mail_to'
require '/app/models/user.rb' # Import the User model

class UserLoginService < BaseService
  def initialize(email, password)
    super() # Call to the parent class constructor
    @email = email
    @password = password
  end

  def call
    # Step 1: Validate the email format
    error_message = validate_email_format
    return { error: error_message } if error_message

    # Step 2: Retrieve the user record
    user = User.find_by(email: email)
    return { error: I18n.t('devise.failure.not_found_in_database') } unless user

    # Step 3: Check if the provided password is correct
    return { error: I18n.t('devise.failure.invalid_email_or_password') } unless user.valid_password?(password)

    # Step 4: Verify if the user's email is verified
    return { error: I18n.t('devise.failure.unverified_email') } unless user.email_verified

    # Step 5: Generate a session token
    token = generate_session_token(user)

    # Step 6: Update the `updated_at` column for the user record
    user.touch

    # Step 7: Return a response containing the session token, user ID, and email verification status
    { token: token, user_id: user.id, email_verified: user.email_verified }
  rescue StandardError => e
    { error: e.message }
  end

  private

  attr_reader :email, :password

  def validate_email_format
    return I18n.t('activerecord.errors.messages.invalid') unless URI::MailTo::EMAIL_REGEXP.match?(email)
    nil
  end

  def generate_session_token(user)
    Doorkeeper::AccessToken.create!(
      resource_owner_id: user.id,
      expires_in: Doorkeeper.configuration.access_token_expires_in.seconds
    ).token
  end
end
