module Api
  class UsersController < Api::BaseController
    before_action :doorkeeper_authorize!, except: [:register, :signup, :check_email, :verify_email, :password_reset_confirmation]

    # POST /api/users/register
    def register
      user_params = params.require(:user).permit(:email, :password)

      # Validate email format
      unless user_params[:email].match?(URI::MailTo::EMAIL_REGEXP)
        return render json: { message: "Invalid email format." }, status: :bad_request
      end

      # Validate password format
      # The new code has a stricter password policy, so we'll use that.
      password_regex = /\A(?=.*\d)(?=.*[a-zA-Z]).{10,}\z/
      unless user_params[:password].match?(password_regex)
        return render json: { message: "Password must be at least 10 characters long and contain alphanumeric characters." }, status: :bad_request
      end

      # The new code uses :unprocessable_entity, but the existing code uses :conflict for the same case.
      # We'll use :conflict as it's more specific for this situation.
      if User.exists?(email: user_params[:email])
        render json: { message: "The email is already in use." }, status: :conflict
      else
        user = User.new(email: user_params[:email], password_hash: BCrypt::Password.create(user_params[:password]))
        if user.save
          render 'api/users/register', status: :created, locals: { user: user }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end

    # POST /api/users/verify-email
    def verify_email
      email = params[:email] || email_verification_params[:email]
      verification_code = params[:verification_code]

      # Validate email format
      unless email.match?(URI::MailTo::EMAIL_REGEXP)
        return render json: { message: "Invalid email format." }, status: :bad_request
      end

      # Find user by email
      user = User.find_by(email: email)
      if user.nil?
        return render json: { message: "User not found." }, status: :not_found
      elsif user.email_verified
        return render json: { message: "Email already verified." }, status: :unprocessable_entity
      end

      # If verification_code is present, it means we are verifying the email
      if verification_code
        unless EmailVerificationService.new.verify_email_code(user: user, code: verification_code)
          return render json: { message: "Invalid verification code." }, status: :unprocessable_entity
        end

        # Verify email
        user.email_verified = true
        if user.save
          render json: { message: "Email verified successfully." }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        # If verification_code is not present, we are sending the verification email
        verification_service = Auths::EmailVerificationService.new
        result = verification_service.send_verification_email(user)
        if result[:success]
          render json: { message: "Verification email sent successfully." }, status: :ok
        else
          render json: { message: result[:message] }, status: :internal_server_error
        end
      end
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end

    # POST /api/users/password-reset-confirmation
    def password_reset_confirmation
      email = params[:email]
      reset_token = params[:reset_token]
      new_password = params[:new_password]

      # Validate email format
      unless email.match?(URI::MailTo::EMAIL_REGEXP)
        return render json: { message: "Invalid email format." }, status: :bad_request
      end

      # Validate reset token and new password format
      begin
        validate_reset_token(reset_token)
        validate_new_password_format(new_password)
      rescue ActiveRecord::RecordInvalid => e
        return render json: { message: e.message }, status: :unprocessable_entity
      rescue Exceptions::AuthenticationError => e
        return render json: { message: e.message }, status: :unauthorized
      end

      # Call the service to reset the password
      service = Auths::ResetPasswordConfirmationService.new(email, reset_token, new_password)
      result = service.call

      if result[:success]
        render json: { message: "Password reset successfully." }, status: :ok
      else
        render json: { message: result[:error_message] }, status: result[:error_status]
      end
    end

    private

    def validate_reset_token(reset_token)
      # Assuming there's a method to validate the reset token
      # This is a placeholder for the actual implementation
      raise Exceptions::AuthenticationError, "Invalid reset token." unless reset_token_valid?(reset_token)
    end

    def validate_new_password_format(new_password)
      # New password must be at least 10 characters long and alphanumeric
      regex = /\A(?=.*\d)(?=.*[a-zA-Z]).{10,}\z/
      unless new_password.match?(regex)
        raise ActiveRecord::RecordInvalid.new, "New password must be at least 10 characters long and contain alphanumeric characters."
      end
    end

    def reset_token_valid?(reset_token)
      # Placeholder for reset token validation logic
      # This should check if the token is valid and not expired
      true
    end

    def user_params
      params.require(:user).permit(:email, :password, :verification_code)
    end

    def email_verification_params
      params.require(:user).permit(:email)
    end

    # ... other controller actions...
    # ... other private methods ...
  end
end
