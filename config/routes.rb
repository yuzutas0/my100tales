Rails.application.routes.draw do
  # locale
  scope '(:locale)', locale: /en|ja/ do
    # home
    root 'home#index'
    get  'home/index'

    # user
    devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }

    # tale
    get    '/mypage',                  to: 'tales#index',  as: 'tales'
    post   '/tales',                   to: 'tales#create', as: 'create_tale'
    get    '/tales/new',               to: 'tales#new',    as: 'new_tale'
    get    '/tales',                   to: 'tales#new'
    get    '/tales/:view_number/edit', to: 'tales#edit',   as: 'edit_tale'
    get    '/tales/:view_number',      to: 'tales#show',   as: 'tale'
    patch  '/tales/:view_number',      to: 'tales#update', as: 'update_tale'
    put    '/tales/:view_number',      to: 'tales#update'
    delete '/tales/:view_number',      to: 'tales#destroy'

    # sequel
    post   '/sequels', to: 'sequels#create', as: 'create_sequel'
    patch  '/sequels', to: 'sequels#update', as: 'update_sequel'
    put    '/sequels', to: 'sequels#update'
    delete '/sequels', to: 'sequels#destroy'

    # tag
    get    '/tags',              to: 'tags#index',  as: 'tags'
    patch  '/tags/:view_number', to: 'tags#update', as: 'tag'
    put    '/tags/:view_number', to: 'tags#update'
    delete '/tags/:view_number', to: 'tags#destroy'

    # score
    get    '/scores',              to: 'scores#index',  as: 'scores'
    patch  '/scores/:view_number', to: 'scores#update', as: 'score'
    put    '/scores/:view_number', to: 'scores#update'
    delete '/scores/:view_number', to: 'scores#destroy'

    # search condition
    get    '/searches',                       to: 'search_conditions#index',  as: 'search_conditions'
    patch  '/search_conditions/:view_number', to: 'search_conditions#update', as: 'search_condition'
    put    '/search_conditions/:view_number', to: 'search_conditions#update'
    delete '/search_conditions/:view_number', to: 'search_conditions#update'

    # no route error
    get    '*all', to: 'application#routing_error'
    post   '*all', to: 'application#routing_error'
    patch  '*all', to: 'application#routing_error'
    put    '*all', to: 'application#routing_error'
    delete '*all', to: 'application#routing_error'

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
end
