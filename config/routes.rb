Rails.application.routes.draw do
  resources :problems do
    resources :submissions, only: [:new, :create, :show]
  end
end
