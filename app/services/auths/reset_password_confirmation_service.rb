require_relative '../../models/user'

module Auths
  class ResetPasswordConfirmationService < BaseService
    include ActiveModel::Validations

    # Updated PASSWORD_FORMAT to match the requirement of alphanumeric characters and at least 10 characters long
    PASSWORD_FORMAT = /\A(?=.*\d)(?=.*[a-zA-Z]).{10,}\z/

    def initialize(user_id, password_reset_token, new_password, new_password_confirmation = nil)
      super()
      @user_id = user_id
      @password_reset_token = password_reset_token
      @new_password = new_password
      @new_password_confirmation = new_password_confirmation || new_password
    end

    def call
      user = find_user
      validate_reset_token_not_expired(user)
      validate_password_length
      validate_password_format
      validate_password_confirmation
      update_password(user)
      invalidate_reset_token(user)
      { success: true, message: 'Password has been reset successfully.' }
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      error_response(e)
    rescue StandardError => e
      error_response(e)
    end

    private

    attr_reader :user_id, :password_reset_token, :new_password, :new_password_confirmation

    def validate_password_length
      if new_password.length < 10
        raise ActiveRecord::RecordInvalid.new, I18n.t('activerecord.errors.messages.too_short', count: 10)
      end
    end

    def validate_password_format
      unless new_password.match(PASSWORD_FORMAT)
        raise ActiveRecord::RecordInvalid.new, I18n.t('activerecord.errors.messages.password_format_invalid')
      end
    end

    def validate_password_confirmation
      unless new_password == new_password_confirmation
        raise ActiveRecord::RecordInvalid.new, I18n.t('activerecord.errors.messages.password_mismatch')
      end
    end

    def find_user
      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordNotFound.new, I18n.t('activerecord.errors.messages.record_not_found') unless user
      user
    end

    def validate_reset_token_not_expired(user)
      unless user.valid_reset_password_token?(password_reset_token)
        raise ActiveRecord::RecordInvalid.new, I18n.t('activerecord.errors.messages.reset_token_invalid_or_expired')
      end
    end

    def update_password(user)
      user.password = new_password
      user.password_salt = SecureRandom.hex
      user.password_hash = BCrypt::Password.create(new_password)
      if user.save
        user.touch(:updated_at)
        true
      else
        raise ActiveRecord::RecordInvalid.new, user.errors.full_messages.to_sentence
      end
    end

    def invalidate_reset_token(user)
      user.update!(reset_password_token: nil, reset_password_sent_at: nil)
    end

    def error_response(exception)
      {
        success: false,
        full_messages: [exception.message],
        errors: exception.record&.errors&.full_messages || [],
        error_message: exception.message,
        backtrace: exception.backtrace
      }
    end
  end
end
