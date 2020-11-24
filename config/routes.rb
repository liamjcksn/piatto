Rails.application.routes.draw do
  devise_for :users, path: 'accounts'
  resources :users do
    resources :dishlists, only: [ :index, :show, :create, :update, :destroy ]
  end
  resources :dishlist_dishes, only: [ :create, :destroy ]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
