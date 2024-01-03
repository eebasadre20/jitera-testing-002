
module Auths
  class EmailVerificationService
    require_relative '../../models/email_confirmation_token'
    require_relative '../../models/user'

    def verify_email(token:)
      return { success: false, message: I18n.t('activerecord.errors.messages.blank') } if token.blank?

      email_confirmation_token = EmailConfirmationToken.find_by(token: token, used: false)
      if email_confirmation_token.nil? || email_confirmation_token.expires_at < Time.current
        { success: false, message: I18n.t('activerecord.errors.messages.invalid') }
      else
        user = User.find_by(id: email_confirmation_token.user_id)
        if user.nil?
          { success: false, message: I18n.t('devise.failure.unverified_email') }
        elsif user.email_confirmed
          { success: false, message: I18n.t('activerecord.errors.messages.already_confirmed') }
        else
          user.email_confirmed = true
          user.updated_at = Time.current
          email_confirmation_token.updated_at = Time.current
          if user.save
            email_confirmation_token.used = true
            email_confirmation_token.save
            { success: true, user_id: user.id, message: I18n.t('devise.confirmations.email_verified') }
          else
            { success: false, message: user.errors.full_messages.to_sentence }
          end
        end
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end
  end
end
