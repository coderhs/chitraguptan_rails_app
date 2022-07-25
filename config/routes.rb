Rails.application.routes.draw do
  namespace :chitraguptan do
    resources :dashboard, only: [:index, :update]
  end
end
