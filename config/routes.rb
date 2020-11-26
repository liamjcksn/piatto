Rails.application.routes.draw do
  root to: 'pages#home'
  get '/discover', to: 'pages#discover', as: 'discover'
  get '/profile/:id', to: 'pages#profile', as: 'profile'
  get '/search', to: 'pages#search', as: 'search'
  
  resources :followings, only: [ :create, :destroy ]

  devise_for :users, path: 'accounts'
  resources :users do
    resources :dishlists, only: [ :index, :show, :create, :update, :destroy ]
  end
  
  resources :dishes do
    resources :reviews, only: [ :create ]
  end
  
  resources :dishlist_dishes, only: [ :create, :destroy ]
  resources :restaurants, only: [ :show ]
  resources :reviews, only: [ :destroy ]
end
