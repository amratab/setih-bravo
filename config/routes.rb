Rails.application.routes.draw do
  namespace :admin do
    resources :users
resources :projects
resources :subscriptions

    root to: "users#index"
  end

  resources :projects
  devise_for :users

  root 'pages#about'

end
