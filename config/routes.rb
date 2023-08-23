Rails.application.routes.draw do
  root to: "pages#home"

  devise_for :users
  resources :job_feeds do
    resources :job_leads, except: [:index, :show]
  end
  resources :job_leads, only: [:index]
end
