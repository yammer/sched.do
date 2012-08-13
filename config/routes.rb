SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  get '/auth/yammer_staging/callback' => 'sessions#create'
  get '/sign_out' => 'sessions#destroy', as: 'sign_out'

  resources :events, only: [:new, :create, :show, :edit, :update], :id => /.{8}/
  resources :votes, only: [:create, :destroy]
  resources :invitations, only: [:create, :update]
  resources :guests, only: [:new, :create, :update]

  root to: "welcome#index"

  if Rails.env.development?
    mount UserMailer::Preview => 'mail_view'
  end
end
