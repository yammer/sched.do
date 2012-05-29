SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  resources :events, only: [:new, :create, :show]

  root to: "welcome#index"
end
