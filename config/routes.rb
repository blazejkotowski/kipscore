Kipscore::Application.routes.draw do

  root :to => 'static_pages#home'

  match '/signup' => 'users#new', :as => 'signup'
  
  resource :user do
    get 'tournaments', :on => :collection
  end
    
  match '/signin' => 'sessions#create', :as => 'signin'  
  match '/signout' => 'sessions#destroy', :as => 'signout'
  
  resources :sessions, :only => [:create, :new, :destroy]

  match '/about' =>  'static_pages#about', :as => 'about'
  match '/contact' => 'static_pages#contact', :as => 'contact', :via => :get
  match '/contact' => 'static_pages#send_email', :as => 'send_email', :via => :post
  match '/instruction' => 'static_pages#instruction', :as => 'instruction'
  match '/innovation' => 'static_pages#innovation', :as => 'innovation'
  
  resources :tournaments do
    put 'activate', :on => :member
    match 'bracket' => 'tournaments#bracket', :via => :get
    match 'bracket' => 'tournaments#bracket_update', :via => :put
    match 'join' => 'players#new', :via => :get
    resources :players, :only => [:create, :destroy]
  end
  
  match 'email-confirm/:email_code' => 'player_associations#activate', :via => :get, :as => 'player_association_activation'
  match 'player_association/:player_id/:tournament_id/confirm' => 'player_associations#confirm', :via => :put, :as => 'player_association_confirmation'
  
end
