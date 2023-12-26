class Api::ExampleAuthsResetPasswordRequestsController < Api::BaseController
  def create
    email = params[:email] || params.dig(:user, :email)
    
    unless email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      return base_render_unprocessable_entity(OpenStruct.new(errors: { email: ["Invalid email format."] }))
    end

    user = User.find_by(email: email)
    if user
      token = user.generate_reset_password_token
      user.send_reset_password_instructions(token)
      render json: { status: 200, message: "Password reset request sent successfully." }, status: :ok
    else
      base_render_record_not_found
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end
