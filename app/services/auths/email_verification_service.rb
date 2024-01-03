
module Auths
  class EmailVerificationService < BaseService
    require_relative '../../models/email_confirmation'
    require_relative '../../models/user'

    def verify_email(id:, email:, token:)
      user = User.find_by(id: id, email: email)
      if user
        email_confirmation = EmailConfirmation.find_by(token: token)
        if email_confirmation.nil?
          { success: false, message: I18n.t('activerecord.errors.messages.invalid') }
        elsif email_confirmation.expires_at < Time.current
          { success: false, message: I18n.t('activerecord.errors.messages.reset_token_invalid_or_expired') }
        else
          email_confirmation.confirmed = true
          if email_confirmation.save
            user.email_verified = true
            if user.save
              { success: true, message: I18n.t('devise.confirmations.email_verified') }
            else
              { success: false, message: user.errors.full_messages.to_sentence }
            end
          else
            { success: false, message: email_confirmation.errors.full_messages.to_sentence }
          end
        end
      else
        { success: false, message: I18n.t('devise.failure.unverified_email') }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end
  end
end
