Rails.application.routes.draw do
  
 #resources :pjmrs, :collection => {:delete_multiple => :post}
 resources :pjmrs do  
  get :lrIndex, on: :collection
  post :import, on: :collection
  put :rksq, on: :collection  
  get :rkdshIndex, on: :collection
  put :rksh, on: :collection
  get :rkIndex, on: :collection 
  put :cksq, on: :collection 
  post :ckpledit, on: :collection
  put :ckplsq, on: :collection
  get :ckdshIndex, on: :collection
  put :cksh, on: :collection
 end

 resources :pjmcs do

 end

 resources :zjtzs do
  get :lrIndex, on: :collection
  put :rjsq, on: :collection
  get :rjdshIndex, on: :collection  
  put :rjsh, on: :collection
  get :rjIndex, on: :collection 
  put :cjsq, on: :collection 
  post :cjpledit, on: :collection 
  get :cjdshIndex, on: :collection
  get :cjdshIndex, on: :collection
  put :cjsh, on: :collection
 end

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only:[:new, :create, :destroy]
  #resources :microposts, only:[:create, :destroy]
  #resources :relationships, only:[:create, :destroy]
  

  root to: 'pjmrs#index'
  match '/signup', to: 'users#new', via: 'get'  
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  
  match '/help', to: 'static_pages#help', via: 'get'
  match '/about', to: 'statmeiic_pages#about', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
