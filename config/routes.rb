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
  match '/contact' => 'static_pages#contact', :as => 'contact'
  
  resources :tournaments do
    put 'activate', :on => :member
    get 'bracket', :on => :member
    resources :players, :only => [:create, :destroy]
    put 'add_player', :on => :member
    put 'remove_player', :on => :member
  end

end
