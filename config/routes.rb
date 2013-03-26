Kipscore::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  
  if Settings.beta_version
    devise_for :users, :controllers => { :registrations => "registrations" } 
  else
    devise_for :users
  end

  resource :user, :only => [:tournaments] do
    match 'tournaments' => 'users#tournaments'
    resource :user_profile, :as => 'profile', :path => 'profile', :only => [:edit, :update]
  end
  
  match "profile/:id" => 'user_profiles#show', :as => "user_profile"

  root :to => 'static_pages#home'

  #match '/signup' => 'users#new', :as => 'signup'
  
  #resource :user do
    #get 'tournaments', :on => :collection
  #end
    
  #match '/signin' => 'sessions#create', :as => 'signin'  
  #match '/signout' => 'sessions#destroy', :as => 'signout'
  
  #resources :sessions, :only => [:create, :new, :destroy]

  match '/about' =>  'static_pages#about', :as => 'about'
  match '/contact' => 'static_pages#contact', :as => 'contact', :via => :get
  match '/contact' => 'static_pages#send_email', :as => 'send_email', :via => :post
  match '/instruction' => 'static_pages#instruction', :as => 'instruction'
  match '/innovation' => 'static_pages#innovation', :as => 'innovation'
  match '/organizer' => 'static_pages#organizer', :as => 'organizer'
  match '/player' => 'static_pages#player', :as => 'player'
  match '/observer' => 'static_pages#observer', :as => 'observer'
  
  resources :tournaments do
    post 'search', :on => :collection
    put 'start', :on => :member
    put 'finish', :on => :member
    match 'bracket' => 'tournaments#bracket', :via => :get
    match 'bracket' => 'tournaments#bracket_update', :via => :put
    match 'rounds' => 'tournaments#rounds', :via => :get
    match 'rounds' => 'tournaments#rounds_update', :via => :put
    match 'results' => 'tournaments#results', :via => :get
    match 'results' => 'tournaments#results_update', :via => :put
    match 'join' => 'players#new', :via => :get
    resources :players, :only => [:create, :destroy]
  end
  
  resources :bracket_tournament, :controller => "tournaments"
  resources :round_robin_tournament, :controller => "tournaments"
  
  match 'email-confirm/:email_code' => 'player_associations#activate', :via => :get, :as => 'player_association_activation'
  match 'player_association/:player_id/:tournament_id/confirm' => 'player_associations#confirm', :via => :put, :as => 'player_association_confirmation'
  
end
