Rails.application.routes.draw do
  root 'bucketeers#index'
  resources :bucketeers, only: :index
end