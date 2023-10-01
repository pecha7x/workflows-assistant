require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :admin do
    authenticate :user, ->(user) { user.is_admin? } do
      mount Sidekiq::Web, at: 'sidekiq'
    end
  end

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'job_leads#index', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resource :assistant_configuration, only: [:settings] do
    get :settings, on: :member
  end
  resources :job_sources do
    resources :job_leads, except: %i[index show]
  end
  resources :job_leads, only: %i[index show]
  resources :notifiers, except: %i[index show] do
    member do
      patch :refresh_telegram_token
    end
  end
  resources :notes, only: %i[new create destroy]
  resources :gmail_messages, only: %i[index show]

  namespace :telegram, defaults: { format: :json } do
    post :message
  end
  namespace :google_oauth2 do
    namespace :gmail do
      get :auth
      get :callback
    end
  end
end

Rails.application.routes.default_url_options[:host] = Rails.application.credentials.host
