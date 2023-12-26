Rails.application.routes.draw do
  # ... other routes ...

  namespace :api do
    # Route for user login
    post 'users/login', to: 'sessions#create'

    # Update the route for password reset request
    post 'users/password-reset-request', to: 'example_auths_reset_password_requests#create'

    # ... other existing routes ...
  end

  # ... other routes ...
end
