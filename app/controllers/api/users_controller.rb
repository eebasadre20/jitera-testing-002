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
      password_regex = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}\z/
      unless user_params[:password].match?(password_regex)
        return render json: { message: "Password must be at least 8 characters long and contain alphanumeric characters." }, status: :bad_request
      end

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
      email = email_verification_params[:email]

      user = User.find_by(email: email)
      if user.nil? || user.email_verified
        render json: { message: "Email not found or already verified." }, status: :not_found
      else
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
      # ... existing code ...
    end

    private

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
