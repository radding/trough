Rails.application.routes.draw do
  get "/users/me", to: "users#me"
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :teams do 
    resources :users
  end
  resources :users  
  resources :tests
  get '/', to: 'application#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
