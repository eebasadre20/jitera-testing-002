Rails.application.routes.draw do
  # ... other routes ...

  namespace :api do
    # ... existing routes ...

    # Update the route for password reset request
    post 'users/password-reset-request', to: 'example_auths_reset_password_requests#create'

    # ... other routes ...
  end

  # ... other routes ...
end
