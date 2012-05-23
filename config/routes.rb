SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  resources :events, only: [:new]

  root to: "welcome#index"
end
