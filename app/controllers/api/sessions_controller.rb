module Api
  class SessionsController < Api::BaseController
    def create
      # Step 1: Validate email format
      unless params[:email].match?(URI::MailTo::EMAIL_REGEXP)
        return render json: { message: "Invalid email format." }, status: :unprocessable_entity
      end

      # Step 2: Validate password format
      unless params[:password].length >= 10 && params[:password].match?(/\A[a-zA-Z0-9]*\z/)
        return render json: { message: "Invalid password format." }, status: :unprocessable_entity
      end

      # Step 3: Find user by email
      user = User.find_by(email: params[:email])
      unless user
        return render json: { message: "Email does not exist." }, status: :unauthorized
      end

      # Step 4: Check if the password is correct
      unless user.valid_password?(params[:password])
        return render json: { message: "Incorrect password." }, status: :unauthorized
      end

      # Step 5: Generate access token
      custom_token_initialize_values(user, Doorkeeper::Application.first)

      # Step 6: Render success response
      render 'api/sessions/create', status: :ok
    rescue StandardError => e
      # Step 7: Handle unexpected errors
      render json: { message: "An unexpected error occurred on the server." }, status: :internal_server_error
    end
  end
end
