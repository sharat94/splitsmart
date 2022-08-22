Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    post 'authenticate', to: 'authentication#authenticate'
    post 'create_user', to: 'users#create_user'
    namespace :v1 do
      resources :expenses
      resources :balances, only: [:index]
    end
  end
end
