SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  get '/sign_out' => 'sessions#destroy', as: 'sign_out'

  resources :events, only: [:new, :create, :show, :edit, :update]
  resources :votes, only: [:create, :destroy]
  resources :invitations, only: [:show]

  root to: "welcome#index"
end
