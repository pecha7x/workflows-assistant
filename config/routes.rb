require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :admin do
    authenticate :user, lambda { |user| user.is_admin? } do
      mount Sidekiq::Web, at: 'sidekiq'
    end
  end

  devise_for :users

  resource :assistant_configuration, only: [:settings] do
    get :settings, on: :member
  end   
  resources :job_sources do
    resources :job_leads, except: [:index, :show]
  end
  resources :job_leads, only: [:index]
  resources :notifiers, except: [:index, :show]
  
  root to: "pages#home"
end
