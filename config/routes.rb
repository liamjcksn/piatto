Rails.application.routes.draw do
  root to: 'pages#home'
  get '/discover', to: 'pages#discover', as: 'discover'
  get '/profile/:id', to: 'pages#profile', as: 'profile'
  get '/search', to: 'pages#search', as: 'search'
  post 'postcode', to: 'pages#postcode'

  devise_for :users, path: 'accounts'
  resources :users do
    resources :dishlists, only: [ :index, :show, :create, :update, :destroy ]
  end

  resources :dishlist_dishes, only: [ :create, :destroy ]
  resources :dishes
  resources :restaurants, only: [ :show, :create ]
end
