Rails.application.routes.draw do
  resources :problems do
    resources :submissions
  end
end
