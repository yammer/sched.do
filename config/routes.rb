SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  resources :events, only: [:new, :create, :show, :edit, :update]
  resources :votes, only: [:create]

  root to: "welcome#index"
end
