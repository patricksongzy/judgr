Rails.application.routes.draw do
  resources :contests, only: [:index, :show]
  resources :problems, only: [:show]
  resources :submissions, only: [:new, :create, :show]

  namespace :admin do
    resources :contests, only: [:new, :create, :destroy]
    resources :problems, only: [:new, :create, :destroy]
  end
end
