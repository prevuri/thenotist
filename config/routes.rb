require 'sidekiq/web'
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

  resources :uploaded_files
    
  resources :notes, :only => [:create]
  match 'notes/grid/:id' => 'notes#show_grid', :as => :grid_note

  resources :profile
  resources :buddies, :only => [:index]
  resources :relationships, :only => [:create, :destroy]
  match 'notes/unsubscribe/:id' => 'notes#unsubscribe', :as => :unsubscribe_note

  namespace :api do
    resources :buddies, :only => [ :index ]
    resources :comments, :only => [ :index, :create, :destroy ]
    resources :files, :only => [ :index, :show ]
    resources :notes, :only => [ :index, :show, :update, :destroy]
    match 'notes/share/' => 'notes#share', :as => :share_note
    match 'notes/unshare/' => 'notes#unshare', :as => :remove_contrib
    match 'notes/contribs/:id' => 'notes#contribs', :as => :note_contribs
  end

  match "/*path" => redirect("/?goto=%{path}")

  # mount sidekiq so we can monitor jobs
  mount Sidekiq::Web, :at => '/sidekiq'

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


