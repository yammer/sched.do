SchedDo::Application.routes.draw do
  get '/auth/yammer/callback' => 'sessions#create'
  get '/auth/yammer_staging/callback' => 'sessions#create'
  get '/dashboard' => 'dashboard#active_users'
  get 'polls' => 'users#show'
  get '/sign_out' => 'sessions#destroy', as: 'sign_out'
  get '/tos' => 'pages#terms_of_service'
  get '/about' => 'welcome#about'

  resources :calendars, only: [:show]
  resources :events, only: [:new, :create, :show, :edit, :update], :id => /.{8}/
  resources :multiple_invitations, only: [:index]
  resources :votes, only: [:create, :update]
  resources :invitations, only: [:create, :update, :destroy]
  resources :guests, only: [:new, :create, :update]
  resources :reminders, only: [:create]
  resources :winning_suggestions, only: [:create]
  resources :yammer_user_invitations, only: [:create]
  resources :yammer_group_invitations, only: [:create]

  resource :dashboard, controller: 'dashboard', only: [:show] do
    collection do
      get 'active_users'
      get 'polls_created'
      get 'users_invited'
      get 'invitee_conversion'
    end
  end

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
