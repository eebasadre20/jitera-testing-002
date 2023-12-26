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

    # ... other controller actions...
    # ... other private methods ...
  end
end
