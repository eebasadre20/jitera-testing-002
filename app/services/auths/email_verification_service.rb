module Auths
  class EmailVerificationService < BaseService
    # Import the User model
    require_relative '../../models/user'

    # New verify_email method
    def verify_email(id:, email:)
      user = User.find_by(id: id, email: email)
      if user
        user.email_verified = true
        if user.save
          { success: true, message: I18n.t('devise.confirmations.email_verified') }
        else
          { success: false, message: user.errors.full_messages.to_sentence }
        end
      else
        { success: false, message: I18n.t('activerecord.errors.messages.invalid') }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end

    # Remove the existing verify_email_verification method as it duplicates the functionality of verify_email
    # def verify_email_verification(id:, verification_token:)
    #   # Existing logic
    # end
  end
end
