Rails.application.routes.draw do
  # ... other routes ...

  namespace :api do
    # ... other existing routes ...

    # Route for user login
    # This route is duplicated in both new and existing code, so we keep it as is.
    post 'users/login', to: 'sessions#create'

    # Route for user registration
    # This route is duplicated in both new and existing code, so we keep it as is.
    post 'users/register', to: 'users#register'

    # Route for email verification
    # This route is duplicated in both new and existing code, so we keep it as is.
    post 'users/verify-email', to: 'users#verify_email'

    # Route for password reset request
    # This route is duplicated in both new and existing code, so we keep it as is.
    post 'users/password-reset-request', to: 'example_auths_reset_password_requests#create'

    # Add route for password reset confirmation
    # This route is only in the new code, so we add it.
    post 'users/password-reset-confirmation', to: 'users#password_reset_confirmation'

    # ... other existing routes ...
  end

  # ... other routes ...
end
