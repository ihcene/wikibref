Wikibref::Application.routes.draw do
  
  get "users/subscribe"

  get "users/login"

  match 'wiki/:slug' => 'articles#show', :as => :wiki_like
  match 'search' => 'search#index', :as => :search
  
  resources :articles do
    member do 
      get 'reload_pictures'
      get 'history'
    end
    
    resources :informations do
      member do 
        get 'history'
      end
    end
  end

  root :to => 'articles#show', :slug => 'Wikibref'
  
  post 'users/login' => 'users#login', :as => 'login_user'
  
  get 'users/subscribe' => 'users#subscribe', :as => 'subscribe'
  post 'users/create' => 'users#create', :as => 'subscribe_create'
  get 'users/logout' => 'users#logout', :as => 'logout_user'
end
