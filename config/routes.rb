require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :admin do
    authenticate :user, ->(user) { user.is_admin? } do
      mount Sidekiq::Web, at: 'sidekiq'
    end
  end

  devise_for :users

  resource :assistant_configuration, only: [:settings] do
    get :settings, on: :member
  end
  resources :job_sources do
    resources :job_leads, except: %i[index show]
  end
  resources :job_leads, only: %i[index show]
  resources :notifiers, except: %i[index show]
  resources :notes, only: %i[new create destroy]

  root to: 'pages#home'
end
