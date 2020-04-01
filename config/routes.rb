Rails.application.routes.draw do
  root to: "contests#index"
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  get "readiness_check", to: proc { [200, {}, ['']] }
  get "liveness_check", to: proc { [200, {}, ['']] }

  get "/confirm_email/:token" => "email_confirmations#update", as: "confirm_email"

  resources :contests, only: [:index, :show]
  resources :problems, only: [:show]
  resources :submissions, only: [:new, :create, :show]

  namespace :admin do
    resources :contests, except: [:show] do
      resources :problems, except: [:show]
    end

    resources :users
  end
end
