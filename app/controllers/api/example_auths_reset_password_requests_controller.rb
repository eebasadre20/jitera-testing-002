class Api::ExampleAuthsResetPasswordRequestsController < Api::BaseController
  require '/app/services/users/check_email_registration_service.rb'

  def create
    email = params[:email] || params.dig(:email)
    
    # Combining the email validation logic from both versions
    unless email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      # Using the existing code's method of rendering errors for consistency
      return base_render_unprocessable_entity(OpenStruct.new(errors: { email: [I18n.t('activerecord.errors.messages.invalid')] }))
    end

    # Check if email is registered using the new code's service
    check_email_service = Users::CheckEmailRegistrationService.new(email)
    unless check_email_service.call
      # Using the existing code's method of rendering not found for consistency
      return base_render_record_not_found
    end

    # Find user by email, considering the user model might be named differently in the existing code
    @example_auth = User.find_by(email: email) || ExampleAuth.find_by(email: email)

    # Send reset password instructions
    if @example_auth.present?
      if @example_auth.respond_to?(:send_reset_password_instructions)
        @example_auth.send_reset_password_instructions
        # Render success response using the new code's message for a more standard API response
        render json: { message: "Password reset request sent successfully." }, status: :ok
      elsif @example_auth.respond_to?(:generate_reset_password_token)
        token = @example_auth.generate_reset_password_token
        # Assuming `UserMailer` is the correct mailer class as per the existing code
        # and `reset_password_instructions` is the correct method
        UserMailer.reset_password_instructions(@example_auth, token).deliver_now
        # Render success response using the new code's message for a more standard API response
        render json: { message: "Password reset link sent successfully." }, status: :ok
      else
        # If neither method exists, we assume failure to process the request
        render json: { message: "Unable to process password reset request." }, status: :internal_server_error
      end
    else
      # Using the existing code's method of rendering not found for consistency
      base_render_record_not_found
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end
