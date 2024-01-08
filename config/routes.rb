require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  namespace :api do
    resources :users, only: [:show] do
      collection do
        get :reservations
      end
    end
    resources :reservations, only: [:show, :update, :destroy], controller: 'reservations'
  end
end
