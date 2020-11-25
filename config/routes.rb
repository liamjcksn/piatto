Rails.application.routes.draw do
  root to: 'pages#home'
  get 'discover', to: 'pages#discover'
  devise_for :users, path: 'accounts'
  resources :users do
    resources :dishlists, only: [ :index, :show, :create, :update, :destroy ]
  end
  resources :dishlist_dishes, only: [ :create, :destroy ]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :dishes
  resources :restaurants, only: [ :show, :index ]
end
