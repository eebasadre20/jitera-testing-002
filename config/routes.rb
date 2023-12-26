Rails.application.routes.draw do
  # ... other routes ...

  namespace :api do
    # Existing routes...

    # Route for password reset request
    post 'users/password-reset-request', to: 'example_auths_reset_password_requests#create'

    # ... other existing routes ...
  end

  # ... other routes ...
end
