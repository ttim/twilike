ActionController::Routing::Routes.draw do |map|
  map.movie 'movie/:small_name', :controller => 'opinions', :action => 'by_movie'

  map.timeline 'timeline', :controller => 'opinions', :action => 'timeline'
  map.top 'top/:time', :controller => 'opinions', :action => 'top'
  map.default_top 'top', :controller => 'opinions', :action => 'top'
  
  map.user_movies 'user/:screen_name', :controller => 'opinions', :action => 'by_user'
  map.search 'search', :controller => 'movies', :action => 'search'

  map.opinion 'opinion/:tweet_id', :controller => 'opinions', :action => 'one'

  map.about 'about', :controller => 'static', :action => 'about'
  map.set_view 'set_view/:view', :controller => 'common', :action => 'set_view'
  
  map.root :controller => 'opinions', :action => 'timeline'

  # work_off
  map.work_off 'work_off.6hfSVJH4', :controller => 'common', :action => 'work_off'

  map.message 'message', :controller => 'static', :action => 'message'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
