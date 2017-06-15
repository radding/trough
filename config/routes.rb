Rails.application.routes.draw do
  resources :teams
  resources :tests
  get '/', to: 'application#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
