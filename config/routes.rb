SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  get '/auth/yammer_staging/callback' => 'sessions#create'
  get 'polls' => 'users#show'
  get '/sign_out' => 'sessions#destroy', as: 'sign_out'
  get '/tos' => 'pages#terms_of_service'

  resources :events, only: [:new, :create, :show, :edit, :update], :id => /.{8}/
  resources :multiple_invitations, only: [:index]
  resources :votes, only: [:create, :destroy]
  resources :invitations, only: [:create, :update]
  resources :guests, only: [:new, :create, :update]
  resources :reminders, only: [:create]
  resources :yammer_user_invitations, only: [:create]
  resources :yammer_group_invitations, only: [:create]

  # Redirects root with param "auth=yammer" to callback with code
  # This is a temporary measure
  get(
    '',
    to: redirect do |segments, request|
      "/auth/yammer/callback?#{request.query_string}"
    end,
    constraints: lambda do |request|
      request.query_string.include?('auth=yammer&code=')
    end
  )

  root to: 'welcome#index'

  if Rails.env.development?
    mount UserMailer::Preview => 'mail_view'
  end
end
