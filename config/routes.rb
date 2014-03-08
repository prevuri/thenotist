# require 'sidekiq/web'
TheNotist::Application.routes.draw do
  resources :activities

  get "buddies/index"

  get "main/index"

  root :to => 'main#index'


  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks"
  }, :skip => [:sessions, :registrations, :passwords]
  as :user do
    get 'signin' => 'main#index', :as => :new_user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :client_views, :only => [:show]

  match "/profile" => redirect("/?goto=profile")
  match "/profile/*id" => redirect("/?goto=profile/%{id}")

  resources :profile
  resources :buddies, :only => [:index]
  resources :relationships, :only => [:create, :destroy]
  match 'notes/unsubscribe/:id' => 'notes#unsubscribe', :as => :unsubscribe_note

  namespace :api do
    match 'notes/upload_form_html' => 'notes#upload_form_html', :as => :upload_form_html
    match 'activity/user/:id' => 'activity#show', :as => :buddy_activity
    match 'activity/user' => 'activity#user', :as => :user_activity
    resources :activity
    resources :users, :only => [ :index, :show ]
    match 'users/:id/friends' => 'users#friends', :as => :user_friends, :via => :get

    resources :comments, :only => [ :index, :create, :destroy ]
    resources :files, :only => [ :index, :show ]
    resources :notes, :only => [ :index, :show, :update, :destroy, :create ]
    match 'notes/share/' => 'notes#share', :as => :share_note
    match 'notes/unshare/' => 'notes#unshare', :as => :remove_contrib
    match 'notes/contribs/:id' => 'notes#contribs', :as => :note_contribs
    match 'notes/paginate/:id' => 'notes#paginate', :as => :note_paginate, :via => :get
    match 'search/notes' => 'search#search_notes', :as => :search_notes, :via => :get
  end

  match "/*path" => redirect("/?goto=%{path}")

  # mount sidekiq so we can monitor jobs
  # mount Sidekiq::Web, :at => '/sidekiq'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
