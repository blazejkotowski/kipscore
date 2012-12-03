Kipscore::Application.routes.draw do

  root :to => 'static_pages#home'

  match '/signup' => 'users#new', :as => 'signup'
  resources :users
  
  match '/signin' => 'sessions#create', :as => 'signin'  
  match '/signout' => 'sessions#destroy', :as => 'signout'
  resources :sessions, :only => [:create, :new, :destroy]

  match '/about' =>  'static_pages#about', :as => 'about'
  match '/contact' => 'static_pages#contact', :as => 'contact'

end
