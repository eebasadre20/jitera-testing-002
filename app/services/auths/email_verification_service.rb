module Auths
  class EmailVerificationService < BaseService
    # Import the User model
    require_relative '../../models/user'

    # Remove the existing verify method if it duplicates the functionality of verify_email_verification
    # def verify(id:, verification_token:)
    #   # Existing logic
    # end

    # New verify_email_verification method
    def verify_email_verification(id:, verification_token:)
      user = User.find_by(id: id)
      return { success: false, message: I18n.t('activerecord.errors.messages.invalid') } if user.nil?

      if user.confirmation_token == verification_token
        user.email_verified = true
        user.updated_at = Time.current
        if user.save
          { success: true, message: I18n.t('devise.confirmations.confirmed') }
        else
          { success: false, message: user.errors.full_messages.to_sentence }
        end
      else
        { success: false, message: I18n.t('devise.failure.unverified_email') }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end

    # Remove the existing verify_email method as it is no longer necessary
    # def verify_email(id:, email:)
    #   # Existing logic
    # end
  end
end
