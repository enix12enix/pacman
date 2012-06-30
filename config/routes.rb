Pacman::Application.routes.draw do
  root :to => "home#index"

  devise_for :users
  
  resources :test_scripts
  
  resources :game_tests, :controller => "testScripts", :_type => "GameTest"
  
  get 'testScripts/category/:id' => 'testScripts#by_category'
  
  get 'accounts/environment/:id' => 'accounts#by_environment'

  resources :testscopes do
    get 'search', :on => :collection
    put 'retest'
    put 'pause'
    put 'restart'
  end
  
  resources :boxes
  
  resources :accounts
  
  resources :instances do
    put 'set_status'
  end
  
  get 'configuration' => 'configuration#index'
  
  put 'testJobs/checkme/:id' => 'testJobs#check_me', :as => "checkme"
  
  get 'testJobs/watchme/:id' => 'testJobs#new_watch_me', :as => "newwatchme"
  
  put 'testJobs/watchme' => 'testJobs#watch_me', :as => "createwatchme"
  
  get 'testJobs/pickup' => 'testJobs#pick_up', :as => "pickup"
  
  post 'testJobs/updateresult' => 'testJobs#update_result'
  
  get 'testJobs/watch' => 'testJobs#watch'
  
  
  # get 'testscopes/search' => 'testscopes#search', :on => :collection
  
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
