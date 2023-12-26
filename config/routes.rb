Rails.application.routes.draw do
  # ... other routes ...

  namespace :api do
    # ... other existing routes ...

    # Route for user registration
    post 'users/register', to: 'users#register'

    # Route for email verification
    post 'users/verify-email', to: 'users#verify_email'

    # Route for password reset request
    post 'users/password-reset-request', to: 'example_auths_reset_password_requests#create'

    # ... other existing routes ...
  end

  # ... other routes ...
end
