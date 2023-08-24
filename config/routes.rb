Rails.application.routes.draw do
  devise_for :users

  resource :assistant_configuration, only: [:settings] do
    get :settings, on: :member
  end   
  resources :job_feeds do
    resources :job_leads, except: [:index, :show]
  end
  resources :job_leads, only: [:index]
  
  root to: "pages#home"
end
