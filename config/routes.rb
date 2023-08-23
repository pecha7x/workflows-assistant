Rails.application.routes.draw do
  devise_for :users

  resources :assistant_configurations, only: [:index]
  resources :job_feeds do
    resources :job_leads, except: [:index, :show]
  end
  resources :job_leads, only: [:index]
  
  root to: "pages#home"
end
