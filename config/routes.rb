Wikibref::Application.routes.draw do
  
  match 'wiki/:slug' => 'articles#show', :as => :wiki_like
  match 'search' => 'search#index', :as => :search
  
  resources :articles do
    resources :informations
  end

  root :to => 'articles#show', :slug => 'Wikibref'
  
  post 'users/login' => 'users#login', :as => 'login_user'
end
