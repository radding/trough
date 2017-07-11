Rails.application.routes.draw do
  get "/users/me", to: "users#me"
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :teams do 
    resources :users
    resources :outings
  end
  resources :users  
  resources :tests
  get '/', to: 'application#index'
  post "/teams/:team_id/outings/:outing_id/users", to: "outings#join"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
