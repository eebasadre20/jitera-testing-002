class Api::ExampleAuthsResetPasswordRequestsController < Api::BaseController
  require '/app/services/users/check_email_registration_service.rb'

  def create
    email = params[:email] || params.dig(:user, :email)
    
    unless email.present? && email.match?(URI::MailTo::EMAIL_REGEXP)
      return base_render_unprocessable_entity(OpenStruct.new(errors: { email: [I18n.t('activerecord.errors.messages.invalid')] }))
    end

    check_email_service = Users::CheckEmailRegistrationService.new(email)
    unless check_email_service.call
      return base_render_record_not_found
    end

    user = User.find_by(email: email)
    if user
      token = user.generate_reset_password_token
      user.send_reset_password_instructions(token)
      render json: { status: 200, message: "Password reset link sent successfully." }, status: :ok
    else
      base_render_record_not_found
    end
  rescue StandardError => e
    render json: { message: e.message }, status: :internal_server_error
  end
end
