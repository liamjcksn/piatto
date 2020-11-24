Rails.application.routes.draw do
  get 'dishlists/index'
  get 'dishlists/show'
  get 'dishlists/create'
  get 'dishlists/update'
  get 'dishlists/destroy'
  devise_for :users do
    resources :dishlists, only: [ :index, :show, :create, :update, :destroy]
  end
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
